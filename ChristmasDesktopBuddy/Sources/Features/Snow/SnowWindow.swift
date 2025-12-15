import SwiftUI
import AppKit

/// 눈 내리는 효과를 표시하는 전체 화면 투명 윈도우
class SnowWindow: NSWindow {
    private var snowView: NSHostingView<SnowEffectView>?

    init() {
        // 메인 화면 전체를 덮는 윈도우
        let screenFrame = NSScreen.main?.frame ?? NSRect(x: 0, y: 0, width: 1920, height: 1080)

        super.init(
            contentRect: screenFrame,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )

        setupWindow()
        setupContent()
    }

    private func setupWindow() {
        // 투명 설정
        self.isOpaque = false
        self.backgroundColor = .clear
        self.hasShadow = false

        // 항상 최상위에 표시하지만 캐릭터보다는 아래에
        self.level = .floating
        self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .ignoresCycle]

        // 타이틀바 숨기기
        self.titleVisibility = .hidden
        self.titlebarAppearsTransparent = true

        // 마우스 이벤트 통과 (클릭이 뒤의 창으로 전달됨)
        self.ignoresMouseEvents = true

        // 다른 앱이 활성화되어도 창 유지
        self.hidesOnDeactivate = false
    }

    private func setupContent() {
        let content = SnowEffectView()
        let hostingView = NSHostingView(rootView: content)
        hostingView.frame = self.contentView?.bounds ?? .zero
        hostingView.autoresizingMask = [.width, .height]

        self.contentView = hostingView
        self.snowView = hostingView
    }

    /// 화면 크기 변경 시 윈도우 크기 업데이트
    func updateFrame() {
        if let screenFrame = NSScreen.main?.frame {
            self.setFrame(screenFrame, display: true)
        }
    }
}

/// 눈 내리는 효과 뷰
struct SnowEffectView: View {
    @State private var snowflakes: [Snowflake] = []
    @State private var timer: Timer?

    private let snowflakeCount = 50
    private let snowflakeSymbols = ["❄", "❅", "❆", "✻", "✼", "❉"]

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(snowflakes) { snowflake in
                    Text(snowflake.symbol)
                        .font(.system(size: snowflake.size))
                        .foregroundColor(.white.opacity(snowflake.opacity))
                        .position(x: snowflake.x, y: snowflake.y)
                }
            }
            .onAppear {
                initializeSnowflakes(in: geometry.size)
                startAnimation(in: geometry.size)
            }
            .onDisappear {
                timer?.invalidate()
                timer = nil
            }
            .onChange(of: geometry.size) { newSize in
                // 화면 크기 변경 시 눈송이 재초기화
                initializeSnowflakes(in: newSize)
            }
        }
        .background(Color.clear)
    }

    private func initializeSnowflakes(in size: CGSize) {
        snowflakes = (0..<snowflakeCount).map { _ in
            Snowflake(
                symbol: snowflakeSymbols.randomElement() ?? "❄",
                x: CGFloat.random(in: 0...size.width),
                y: CGFloat.random(in: -50...size.height),
                size: CGFloat.random(in: 10...24),
                opacity: Double.random(in: 0.4...0.9),
                speed: CGFloat.random(in: 30...80),
                wobble: CGFloat.random(in: -1...1)
            )
        }
    }

    private func startAnimation(in size: CGSize) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0 / 30.0, repeats: true) { _ in
            updateSnowflakes(in: size)
        }
        if let timer = timer {
            RunLoop.main.add(timer, forMode: .common)
        }
    }

    private func updateSnowflakes(in size: CGSize) {
        for i in snowflakes.indices {
            // 아래로 이동
            snowflakes[i].y += snowflakes[i].speed / 30.0

            // 좌우로 약간 흔들림
            snowflakes[i].x += snowflakes[i].wobble
            snowflakes[i].wobble += CGFloat.random(in: -0.1...0.1)
            snowflakes[i].wobble = max(-2, min(2, snowflakes[i].wobble))

            // 화면 아래로 벗어나면 위에서 다시 시작
            if snowflakes[i].y > size.height + 50 {
                snowflakes[i].y = -50
                snowflakes[i].x = CGFloat.random(in: 0...size.width)
                snowflakes[i].speed = CGFloat.random(in: 30...80)
            }

            // 화면 좌우로 벗어나면 반대편에서 나타남
            if snowflakes[i].x < -20 {
                snowflakes[i].x = size.width + 20
            } else if snowflakes[i].x > size.width + 20 {
                snowflakes[i].x = -20
            }
        }
    }
}

/// 눈송이 모델
struct Snowflake: Identifiable {
    let id = UUID()
    let symbol: String
    var x: CGFloat
    var y: CGFloat
    let size: CGFloat
    let opacity: Double
    var speed: CGFloat
    var wobble: CGFloat
}
