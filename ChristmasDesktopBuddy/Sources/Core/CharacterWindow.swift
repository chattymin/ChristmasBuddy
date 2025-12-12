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
        self.collectionBehavior = [.canJoinAllSpaces, .stationary, .fullScreenAuxiliary]

        // 타이틀바 숨기기
        self.titleVisibility = .hidden
        self.titlebarAppearsTransparent = true

        // 다른 앱이 활성화되어도 창 유지
        self.hidesOnDeactivate = false

        // 창이 키 윈도우가 되는 것을 허용
        self.isMovableByWindowBackground = false
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
}

/// 캐릭터 윈도우 콘텐츠 뷰
struct CharacterWindowContent: View {
    let characterType: CharacterType
    let characterSize: CGFloat

    @State private var showInfo = false
    @State private var infoItems: [InfoItem] = []
    @State private var currentMessage = ""
    @State private var isDragging = false
    @State private var lastDragValue: CGSize = .zero

    private let providers: [InfoProvider] = [
        BatteryProvider(),
        TimeProvider()
    ]
    private let messageGenerator = MessageGenerator()

    var body: some View {
        ZStack {
            // 투명 배경 (드래그 영역)
            Color.clear
                .contentShape(Rectangle())

            // 캐릭터
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    CharacterView(characterType: characterType, size: characterSize)
                        .onTapGesture {
                            handleTap()
                        }
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    if !isDragging {
                                        isDragging = true
                                        showInfo = false
                                        lastDragValue = .zero
                                    }

                                    // 이전 위치와의 차이만큼 윈도우 이동 (실시간)
                                    let delta = CGSize(
                                        width: value.translation.width - lastDragValue.width,
                                        height: value.translation.height - lastDragValue.height
                                    )
                                    moveWindow(by: delta)
                                    lastDragValue = value.translation
                                }
                                .onEnded { _ in
                                    isDragging = false
                                    lastDragValue = .zero
                                }
                        )
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

    /// 윈도우 이동
    private func moveWindow(by offset: CGSize) {
        guard let window = NSApp.windows.first(where: { $0 is CharacterWindow }) else {
            return
        }

        var newOrigin = window.frame.origin
        newOrigin.x += offset.width
        newOrigin.y -= offset.height // SwiftUI 좌표계는 반대

        window.setFrameOrigin(newOrigin)
    }
}
