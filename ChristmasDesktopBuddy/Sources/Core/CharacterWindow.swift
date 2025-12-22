import SwiftUI
import AppKit

/// 투명한 floating window - 캐릭터를 표시하고 상호작용을 처리
class CharacterWindow: NSWindow {
    private var characterType: CharacterType
    private let characterSize: CGFloat = 80
    private var hostingView: NSHostingView<CharacterWindowContent>?
    weak var boxManager: BoxManager?

    init(characterType: CharacterType = .snowman, boxManager: BoxManager? = nil) {
        self.characterType = characterType
        self.boxManager = boxManager

        // 화면 좌측 하단에 윈도우 위치
        let windowWidth: CGFloat = 300
        let windowHeight: CGFloat = 300

        var initialX: CGFloat = 100
        var initialY: CGFloat = 100

        if let screen = NSScreen.main {
            let screenFrame = screen.visibleFrame
            initialX = screenFrame.minX - 20
            initialY = screenFrame.minY - 70
        }

        let windowRect = NSRect(x: initialX, y: initialY, width: windowWidth, height: windowHeight)

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
            characterSize: characterSize,
            boxManager: boxManager,
            characterWindow: self
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

    /// 화면 변경 시 캐릭터 위치 재조정
    func handleScreenChange() {
        guard let screen = NSScreen.main else { return }
        let screenFrame = screen.visibleFrame
        let currentPosition = self.frame.origin

        // 새로운 홈 위치 계산
        let newHomePosition = CGPoint(
            x: screenFrame.minX - 20,
            y: screenFrame.minY - 70
        )

        // 캐릭터가 화면 밖에 있는지 확인
        let windowWidth = self.frame.width
        let windowHeight = self.frame.height
        let isOutOfScreen = currentPosition.x + windowWidth < screenFrame.minX ||
                           currentPosition.x > screenFrame.maxX ||
                           currentPosition.y + windowHeight < screenFrame.minY ||
                           currentPosition.y > screenFrame.maxY

        if isOutOfScreen {
            // 화면 밖에 있으면 홈 위치로 이동
            print("🎅 캐릭터가 화면 밖에 있어 홈 위치로 이동: \(currentPosition) → \(newHomePosition)")
            self.setFrameOrigin(newHomePosition)
        } else {
            // 화면 내에 있으면 범위 내로 조정
            var adjustedX = currentPosition.x
            var adjustedY = currentPosition.y

            // 화면 범위 내로 조정 (약간의 여백 허용)
            let margin: CGFloat = 50
            adjustedX = max(screenFrame.minX - windowWidth + margin, min(screenFrame.maxX - margin, adjustedX))
            adjustedY = max(screenFrame.minY - windowHeight + margin, min(screenFrame.maxY - margin, adjustedY))

            if adjustedX != currentPosition.x || adjustedY != currentPosition.y {
                print("🎅 캐릭터 위치 조정: \(currentPosition) → (\(adjustedX), \(adjustedY))")
                self.setFrameOrigin(CGPoint(x: adjustedX, y: adjustedY))
            }
        }
    }

    /// 홈 위치로 이동
    func moveToHomePosition() {
        guard let screen = NSScreen.main else { return }
        let screenFrame = screen.visibleFrame
        let homePosition = CGPoint(
            x: screenFrame.minX - 20,
            y: screenFrame.minY - 70
        )
        self.setFrameOrigin(homePosition)
        print("🏠 캐릭터를 홈 위치로 이동: \(homePosition)")
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
    weak var boxManager: BoxManager?
    weak var characterWindow: CharacterWindow?

    @State private var showInfo = false
    @State private var infoItems: [InfoItem] = []
    @State private var currentMessage = ""

    // 드래그 관련 상태
    @State private var isDragging = false
    @State private var dragStartTime: Date?
    @State private var isDizzy = false
    @State private var wobbleRotation: Double = 0
    @State private var dragTimer: Timer?

    // 상자 수집 관련 상태
    @State private var isCollectingBox = false
    @State private var checkBoxTimer: Timer?
    @State private var carriedBoxId: UUID? = nil  // 현재 들고 있는 상자 ID

    // 캐릭터 방향
    @State private var facingLeft = false  // 좌측을 향하는지 여부

    // 아이들 애니메이션
    @State private var idleFrameIndex = 0  // 현재 아이들 프레임 인덱스
    @State private var idleAnimationTimer: Timer?

    // 랜덤 인사 관련
    @ObservedObject private var greetingManager = RandomGreetingManager.shared
    @State private var showRandomGreeting = false
    @State private var randomGreetingMessage = ""
    @State private var greetingDismissTimer: Timer?

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
                        CharacterView(
                            characterType: characterType,
                            size: characterSize,
                            isDizzy: isDizzy,
                            facingLeft: facingLeft,
                            idleFrameIndex: idleFrameIndex
                        )
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

            // 랜덤 인사 말풍선
            if showRandomGreeting {
                VStack {
                    HStack {
                        Spacer()
                        RandomGreetingBubbleView(message: randomGreetingMessage)
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
        .onAppear {
            startBoxCheckTimer()
            startIdleAnimation()
            greetingManager.startTimer()
        }
        .onDisappear {
            checkBoxTimer?.invalidate()
            idleAnimationTimer?.invalidate()
            greetingDismissTimer?.invalidate()
        }
        .onChange(of: greetingManager.shouldShowGreeting) { newValue in
            if newValue {
                showRandomGreetingBubble()
            }
        }
    }

    /// 랜덤 인사 말풍선 표시
    private func showRandomGreetingBubble() {
        // 이미 정보창이 열려있으면 표시하지 않음
        guard !showInfo else {
            greetingManager.hideGreeting()
            return
        }

        randomGreetingMessage = greetingManager.greetingMessage
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            showRandomGreeting = true
        }

        // 5초 후 자동으로 숨기기
        greetingDismissTimer?.invalidate()
        greetingDismissTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { _ in
            dismissRandomGreeting()
        }
        if let timer = greetingDismissTimer {
            RunLoop.main.add(timer, forMode: .common)
        }

        greetingManager.hideGreeting()
    }

    /// 랜덤 인사 말풍선 숨기기
    private func dismissRandomGreeting() {
        greetingDismissTimer?.invalidate()
        greetingDismissTimer = nil
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            showRandomGreeting = false
        }
    }

    /// 탭 핸들러
    private func handleTap() {
        // 랜덤 인사 말풍선이 표시 중이면 숨기기
        if showRandomGreeting {
            dismissRandomGreeting()
            return
        }

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

    /// 상자 체크 타이머 시작
    private func startBoxCheckTimer() {
        print("⏰ 상자 체크 타이머 시작!")
        checkBoxTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            print("🔍 상자 체크 중...")
            checkAndCollectBoxes()
        }
    }

    /// 아이들 애니메이션 시작
    private func startIdleAnimation() {
        idleAnimationTimer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { [self] _ in
            // 바쁘지 않을 때만 애니메이션 (상자 수집 중이거나 드래그 중이면 애니메이션 멈춤)
            if !isCollectingBox && !isDragging {
                idleFrameIndex = (idleFrameIndex + 1) % 3
            }
        }
    }

    /// 흩어진 상자 확인 및 수집
    private func checkAndCollectBoxes() {
        guard !isCollectingBox,
              let manager = boxManager,
              let window = characterWindow else { return }

        let scatteredBoxes = manager.getScatteredBoxes()
        if let firstBox = scatteredBoxes.first {
            print("🎯 캐릭터가 상자를 발견했습니다!")
            isCollectingBox = true
            collectBox(firstBox, characterWindow: window, manager: manager)
        }
    }

    /// 상자 수집 (이동 -> 줍기 -> 들고 이동 -> 내려놓기)
    private func collectBox(_ box: Box, characterWindow: CharacterWindow, manager: BoxManager) {
        // 캐릭터 윈도우와 상자 윈도우의 크기 차이를 고려하여 중앙 정렬
        let characterWindowSize: CGFloat = 300
        let boxWindowSize: CGFloat = 48
        let offset = (characterWindowSize - boxWindowSize) / 2

        let alignedBoxPosition = CGPoint(
            x: box.position.x - offset,
            y: box.position.y - offset
        )

        let stackPosition = getOriginalStackPosition(for: box.id, in: manager)
        let alignedStackPosition = CGPoint(
            x: stackPosition.x - offset,
            y: stackPosition.y - offset
        )

        print("🚶 캐릭터가 상자로 이동 시작: \(box.position) -> 정렬된 위치: \(alignedBoxPosition)")

        // 1단계: 상자 위치로 이동 (중앙 정렬)
        moveCharacterTo(position: alignedBoxPosition, characterWindow: characterWindow) {
            print("✋ 상자 도착! 들어올리는 중...")

            // 2단계: 상자 들기 (딜레이 최소화)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                carriedBoxId = box.id
                print("📦 상자를 들었습니다!")

                // 3단계: 상자를 들고 원래 쌓여있던 위치로 이동 (정렬된 위치)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    print("🚶 상자를 들고 원위치로 이동 중...")
                    moveCharacterToWithBox(
                        position: alignedStackPosition,
                        characterWindow: characterWindow,
                        boxId: box.id,
                        manager: manager
                    ) {
                        // 4단계: 상자 내려놓기
                        print("📦 상자를 내려놓습니다!")
                        manager.returnBoxToOriginalPosition(id: box.id)
                        carriedBoxId = nil

                        // 5단계: 다음 흩어진 상자 확인 (딜레이 최소화)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                            let scatteredBoxes = manager.getScatteredBoxes()
                            if let nextBox = scatteredBoxes.first {
                                // 다음 상자가 있으면 바로 수집
                                print("🔄 다음 상자로 이동!")
                                collectBox(nextBox, characterWindow: characterWindow, manager: manager)
                            } else {
                                // 모든 상자 정리 완료 - 좌측 하단으로 이동
                                print("🏠 모든 상자 정리 완료! 좌측 하단으로 이동 중...")
                                if let screen = NSScreen.main {
                                    let screenFrame = screen.visibleFrame
                                    // 캐릭터가 화면 왼쪽 아래 구석에 오도록 윈도우 위치 조정
                                    // 캐릭터가 잘리지 않도록 적절한 offset 사용
                                    let homePosition = CGPoint(
                                        x: screenFrame.minX - 20,
                                        y: screenFrame.minY - 70
                                    )
                                    moveCharacterTo(position: homePosition, characterWindow: characterWindow) {
                                        print("✅ 상자 수집 완료!")
                                        isCollectingBox = false
                                        facingLeft = false  // 오른쪽을 바라보도록
                                    }
                                } else {
                                    isCollectingBox = false
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    /// 상자의 원래 스택 위치 계산
    private func getOriginalStackPosition(for boxId: UUID, in manager: BoxManager) -> CGPoint {
        if let index = manager.boxes.firstIndex(where: { $0.id == boxId }) {
            let boxSize: CGFloat = 48
            let stackSpacing: CGFloat = 4
            if let screen = NSScreen.main {
                let screenFrame = screen.visibleFrame
                let originalStackPosition = CGPoint(
                    x: screenFrame.maxX - boxSize - 20,
                    y: screenFrame.minY + 20
                )
                let yOffset = CGFloat(index) * (boxSize + stackSpacing)
                return CGPoint(
                    x: originalStackPosition.x,
                    y: originalStackPosition.y + yOffset
                )
            }
        }
        return CGPoint(x: 100, y: 100)
    }

    /// 캐릭터를 특정 위치로 이동 (프레임 단위로 부드럽게)
    private func moveCharacterTo(position: CGPoint, characterWindow: CharacterWindow, completion: @escaping () -> Void) {
        let startPosition = characterWindow.frame.origin
        let distance = sqrt(pow(position.x - startPosition.x, 2) + pow(position.y - startPosition.y, 2))
        let speed: CGFloat = 600  // 초당 600픽셀
        let totalDuration = TimeInterval(distance / speed)
        let frameRate: TimeInterval = 1.0 / 60.0  // 60fps

        // 이동 방향 감지 (왼쪽으로 이동하면 facingLeft = true)
        if position.x < startPosition.x {
            facingLeft = true
        } else if position.x > startPosition.x {
            facingLeft = false
        }

        var elapsed: TimeInterval = 0
        var timer: Timer?

        timer = Timer.scheduledTimer(withTimeInterval: frameRate, repeats: true) { t in
            elapsed += frameRate
            let progress = min(elapsed / totalDuration, 1.0)

            // 이징 함수 (easeInOut)
            let easedProgress = progress < 0.5
                ? 2 * progress * progress
                : 1 - pow(-2 * progress + 2, 2) / 2

            let currentX = startPosition.x + (position.x - startPosition.x) * easedProgress
            let currentY = startPosition.y + (position.y - startPosition.y) * easedProgress

            characterWindow.setFrameOrigin(CGPoint(x: currentX, y: currentY))

            if progress >= 1.0 {
                t.invalidate()
                completion()
            }
        }
    }

    /// 캐릭터가 상자를 들고 이동 (상자도 함께 프레임 단위로)
    private func moveCharacterToWithBox(
        position: CGPoint,
        characterWindow: CharacterWindow,
        boxId: UUID,
        manager: BoxManager,
        completion: @escaping () -> Void
    ) {
        let startPosition = characterWindow.frame.origin
        let distance = sqrt(pow(position.x - startPosition.x, 2) + pow(position.y - startPosition.y, 2))
        let speed: CGFloat = 600  // 초당 600픽셀
        let totalDuration = TimeInterval(distance / speed)
        let frameRate: TimeInterval = 1.0 / 60.0  // 60fps

        // 이동 방향 감지 (왼쪽으로 이동하면 facingLeft = true)
        if position.x < startPosition.x {
            facingLeft = true
        } else if position.x > startPosition.x {
            facingLeft = false
        }

        // 캐릭터 윈도우 중앙에 상자를 위치시키기
        let characterWindowSize: CGFloat = 300
        let boxWindowSize: CGFloat = 48
        let centerOffset = (characterWindowSize - boxWindowSize) / 2
        let boxOffset = CGPoint(x: centerOffset, y: centerOffset + 40)  // 캐릭터 중앙 약간 위

        var elapsed: TimeInterval = 0
        var timer: Timer?

        timer = Timer.scheduledTimer(withTimeInterval: frameRate, repeats: true) { t in
            elapsed += frameRate
            let progress = min(elapsed / totalDuration, 1.0)

            // 이징 함수 (easeInOut)
            let easedProgress = progress < 0.5
                ? 2 * progress * progress
                : 1 - pow(-2 * progress + 2, 2) / 2

            let currentX = startPosition.x + (position.x - startPosition.x) * easedProgress
            let currentY = startPosition.y + (position.y - startPosition.y) * easedProgress

            // 캐릭터 이동
            characterWindow.setFrameOrigin(CGPoint(x: currentX, y: currentY))

            // 상자도 캐릭터와 함께 이동
            if let boxWindow = manager.boxWindows[boxId] {
                let boxX = currentX + boxOffset.x
                let boxY = currentY + boxOffset.y
                boxWindow.setFrameOrigin(CGPoint(x: boxX, y: boxY))
            }

            if progress >= 1.0 {
                t.invalidate()
                completion()
            }
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
