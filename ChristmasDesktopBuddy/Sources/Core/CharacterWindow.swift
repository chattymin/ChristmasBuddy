import SwiftUI
import AppKit

/// 투명한 floating window - 캐릭터를 표시하고 상호작용을 처리
class CharacterWindow: NSWindow {
    private var characterType: CharacterType
    private let characterSize: CGFloat = 80
    private var hostingView: NSHostingView<CharacterWindowContent>?

    init(characterType: CharacterType = .snowman) {
        self.characterType = characterType

        // 화면 중앙에 윈도우 위치
        let windowRect = NSRect(x: 100, y: 100, width: 300, height: 300)

        super.init(
            contentRect: windowRect,
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

        // 항상 최상위에 표시
        self.level = .floating
        self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .ignoresCycle]

        // 타이틀바 숨기기
        self.titleVisibility = .hidden
        self.titlebarAppearsTransparent = true

        // 다른 앱이 활성화되어도 창 유지
        self.hidesOnDeactivate = false

        // 윈도우 이동 가능하게 설정 (네이티브 드래그 사용)
        self.isMovable = true
        self.isMovableByWindowBackground = true

        // 화면 제약 해제 - 메뉴바 위로 이동 가능하도록
        self.styleMask.insert(.fullSizeContentView)
    }

    private func setupContent() {
        let content = CharacterWindowContent(
            characterType: characterType,
            characterSize: characterSize
        )

        let hostingView = NSHostingView(rootView: content)
        hostingView.frame = self.contentView?.bounds ?? .zero
        hostingView.autoresizingMask = [.width, .height]

        self.contentView = hostingView
        self.hostingView = hostingView
    }

    /// 캐릭터 변경
    func changeCharacter(to type: CharacterType) {
        self.characterType = type
        setupContent()
    }

    /// 화면 제약 완전히 해제 - 메뉴바 위로도 이동 가능
    override func constrainFrameRect(_ frameRect: NSRect, to screen: NSScreen?) -> NSRect {
        return frameRect // 제약 없이 그대로 반환
    }
}

/// 캐릭터 윈도우 콘텐츠 뷰
struct CharacterWindowContent: View {
    let characterType: CharacterType
    let characterSize: CGFloat

    @State private var showInfo = false
    @State private var infoItems: [InfoItem] = []
    @State private var currentMessage = ""

    // 드래그 관련 상태
    @State private var isDragging = false
    @State private var dragStartTime: Date?
    @State private var isDizzy = false
    @State private var wobbleRotation: Double = 0
    @State private var dragTimer: Timer?

    private let providers: [InfoProvider] = [
        BatteryProvider(),
        TimeProvider()
    ]
    private let messageGenerator = MessageGenerator()

    var body: some View {
        ZStack {
            // 투명 배경 (외부 클릭 감지)
            if showInfo {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        // 외부 클릭 시 정보창 닫기
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            showInfo = false
                        }
                    }
            }

            // 캐릭터
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    ZStack {
                        // 어지러워하는 이펙트 - 별들
                        if isDizzy && !isDragging {
                            DizzyStarsEffect()
                        }

                        // 캐릭터
                        CharacterView(characterType: characterType, size: characterSize, isDizzy: isDizzy)
                            .rotationEffect(isDizzy && !isDragging ? .degrees(wobbleRotation) : .zero)
                            .onTapGesture {
                                handleTap()
                            }
                            .simultaneousGesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { _ in
                                        handleDragChanged()
                                    }
                                    .onEnded { _ in
                                        handleDragEnded()
                                    }
                            )
                    }
                    Spacer()
                }
                Spacer()
            }

            // 정보 말풍선
            if showInfo && !infoItems.isEmpty {
                VStack {
                    HStack {
                        Spacer()
                        InfoBubbleView(items: infoItems, message: currentMessage)
                            .transition(.scale.combined(with: .opacity))
                            .padding()
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }

    /// 탭 핸들러
    private func handleTap() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            showInfo.toggle()
        }

        if showInfo {
            loadInfo()
        }
    }

    /// 정보 로드
    private func loadInfo() {
        Task {
            var items: [InfoItem] = []

            for provider in providers {
                let item = await provider.getInfoItem()
                items.append(item)
            }

            await MainActor.run {
                self.infoItems = items
                self.currentMessage = messageGenerator.getRandomMessage()
            }
        }
    }

    /// 드래그 시작/변경 핸들러
    private func handleDragChanged() {
        // 드래그 시작 시점 기록
        if dragStartTime == nil {
            dragStartTime = Date()
            isDragging = true

            // 타이머로 드래그 시간 체크
            dragTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                if let startTime = dragStartTime,
                   Date().timeIntervalSince(startTime) >= 5.0,
                   !isDizzy {
                    // 어지러워하는 상태로 변경
                    withAnimation {
                        isDizzy = true
                    }
                    startWobbleAnimation()
                    dragTimer?.invalidate()
                    dragTimer = nil
                }
            }
        }
    }

    /// 드래그 종료 핸들러
    private func handleDragEnded() {
        isDragging = false
        dragStartTime = nil
        dragTimer?.invalidate()
        dragTimer = nil

        // 어지러워하는 상태라면 3초 후 복구
        if isDizzy {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation {
                    isDizzy = false
                    wobbleRotation = 0
                }
            }
        }
    }

    /// 흔들림 애니메이션 시작
    private func startWobbleAnimation() {
        withAnimation(
            Animation.easeInOut(duration: 0.15)
                .repeatForever(autoreverses: true)
        ) {
            wobbleRotation = 15  // 좌우로 15도씩 흔들림
        }
    }
}

/// 어지러워하는 상태의 별 이펙트
struct DizzyStarsEffect: View {
    @State private var rotation: Double = 0

    var body: some View {
        ZStack {
            // 왼쪽 위 별
            Text("⭐")
                .font(.system(size: 20))
                .offset(x: -40, y: -40)
                .rotationEffect(.degrees(rotation))

            // 오른쪽 위 별
            Text("⭐")
                .font(.system(size: 20))
                .offset(x: 40, y: -40)
                .rotationEffect(.degrees(-rotation))

            // 왼쪽 아래 별
            Text("✨")
                .font(.system(size: 16))
                .offset(x: -45, y: 25)
                .rotationEffect(.degrees(rotation * 1.5))

            // 오른쪽 아래 별
            Text("✨")
                .font(.system(size: 16))
                .offset(x: 45, y: 25)
                .rotationEffect(.degrees(-rotation * 1.5))
        }
        .onAppear {
            withAnimation(
                Animation.linear(duration: 2.0)
                    .repeatForever(autoreverses: false)
            ) {
                rotation = 360
            }
        }
    }
}
