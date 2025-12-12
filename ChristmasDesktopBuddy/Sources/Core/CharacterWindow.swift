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
                    CharacterView(characterType: characterType, size: characterSize)
                        .onTapGesture {
                            handleTap()
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
}
