import SwiftUI
import AppKit

/// 선물 상자를 표시하는 floating window
class BoxWindow: NSWindow {
    private let boxId: UUID
    private let boxSize: CGFloat = 48
    private weak var boxManager: BoxManager?
    private var positionUpdateTimer: Timer?

    init(box: Box, boxManager: BoxManager) {
        self.boxId = box.id
        self.boxManager = boxManager

        let windowRect = NSRect(
            x: box.position.x,
            y: box.position.y,
            width: boxSize,
            height: boxSize
        )

        super.init(
            contentRect: windowRect,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )

        setupWindow()
        setupContent()
        startPositionTracking()
    }

    private func setupWindow() {
        self.isOpaque = false
        self.backgroundColor = .clear
        self.hasShadow = false
        self.level = .floating
        self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .ignoresCycle]
        self.titleVisibility = .hidden
        self.titlebarAppearsTransparent = true
        self.hidesOnDeactivate = false
        self.isMovable = true
        self.isMovableByWindowBackground = true
        self.styleMask.insert(.fullSizeContentView)
    }

    private func setupContent() {
        let content = BoxView(boxSize: boxSize)
        let hostingView = NSHostingView(rootView: content)
        hostingView.frame = self.contentView?.bounds ?? .zero
        hostingView.autoresizingMask = [.width, .height]
        self.contentView = hostingView
    }

    override func constrainFrameRect(_ frameRect: NSRect, to screen: NSScreen?) -> NSRect {
        return frameRect
    }

    /// 위치 추적 시작
    private func startPositionTracking() {
        positionUpdateTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.boxManager?.updateBoxPosition(id: self.boxId, to: self.frame.origin)
        }
    }

    deinit {
        positionUpdateTimer?.invalidate()
    }
}

/// 선물 상자 뷰
struct BoxView: View {
    let boxSize: CGFloat

    var body: some View {
        Group {
            if let svgData = loadSVG(),
               let nsImage = NSImage(data: svgData) {
                Image(nsImage: nsImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: boxSize, height: boxSize)
            } else {
                // 폴백 이모지
                Text("🎁")
                    .font(.system(size: boxSize * 0.8))
            }
        }
    }

    private func loadSVG() -> Data? {
        guard let url = ResourceBundle.bundle.url(forResource: "gift-box", withExtension: "svg") else {
            print("❌ gift-box SVG not found")
            return nil
        }
        return try? Data(contentsOf: url)
    }
}
