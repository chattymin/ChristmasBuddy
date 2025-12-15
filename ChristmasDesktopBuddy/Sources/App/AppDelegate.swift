import Cocoa
import SwiftUI

/// Visibility 모드
enum VisibilityMode {
    case characterOnly      // 캐릭터만 보임
    case characterAndBoxes  // 캐릭터와 상자 모두 보임
    case hidden            // 둘 다 안 보임
}

/// 앱 델리게이트
class AppDelegate: NSObject, NSApplicationDelegate {
    private var characterWindow: CharacterWindow?
    private var statusItem: NSStatusItem?
    private var visibilityMenuItems: [VisibilityMode: NSMenuItem] = [:]
    private var scatterBoxesMenuItem: NSMenuItem?
    private var boxManager: BoxManager?
    private var boxWindows: [BoxWindow] = []
    private var currentVisibilityMode: VisibilityMode = .characterAndBoxes

    // 메뉴바 아이콘 애니메이션
    private var menuBarAnimationTimer: Timer?
    private var menuBarFrameIndex = 0
    private var menuBarImages: [NSImage] = []

    func applicationDidFinishLaunching(_ notification: Notification) {
        print("🎄 Christmas Desktop Buddy 시작!")

        // 상자 매니저 생성
        boxManager = BoxManager()

        // 상자 윈도우들 생성
        setupBoxWindows()

        // 캐릭터 윈도우 생성 (boxManager 전달)
        characterWindow = CharacterWindow(characterType: .snowman, boxManager: boxManager)
        characterWindow?.makeKeyAndOrderFront(nil)

        // 메뉴바 아이템 생성
        setupMenuBar()

        // 초기 visibility 상태 적용
        updateVisibility()

        // Dock 아이콘 숨기기 (옵션)
        NSApp.setActivationPolicy(.accessory)
    }

    /// 상자 윈도우들 생성
    private func setupBoxWindows() {
        guard let manager = boxManager else { return }

        boxWindows = manager.boxes.map { box in
            let window = BoxWindow(box: box, boxManager: manager)
            window.makeKeyAndOrderFront(nil)
            // BoxManager에 윈도우 등록
            manager.boxWindows[box.id] = window
            return window
        }

        print("📦 선물 상자 \(boxWindows.count)개 생성")
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        // 윈도우가 닫혀도 앱은 계속 실행
        return false
    }

    /// 메뉴바 설정
    private func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        // 메뉴바 아이콘 이미지 로드
        loadMenuBarImages()

        if let button = statusItem?.button, let firstImage = menuBarImages.first {
            button.image = firstImage
            button.image?.isTemplate = false
        }

        // 메뉴바 아이콘 애니메이션 시작
        startMenuBarAnimation()

        let menu = NSMenu()
        // 메뉴 아이템 활성화/비활성화를 수동으로 제어
        menu.autoenablesItems = false

        // 캐릭터 변경 메뉴
        let characterMenu = NSMenu()
        for type in CharacterType.allCases {
            let item = NSMenuItem(
                title: type.displayName,
                action: #selector(changeCharacter(_:)),
                keyEquivalent: ""
            )
            item.tag = CharacterType.allCases.firstIndex(of: type) ?? 0
            characterMenu.addItem(item)
        }

        let characterMenuItem = NSMenuItem(title: "캐릭터 변경", action: nil, keyEquivalent: "")
        characterMenuItem.submenu = characterMenu
        menu.addItem(characterMenuItem)

        menu.addItem(NSMenuItem.separator())

        // 선물 퍼트리기
        scatterBoxesMenuItem = NSMenuItem(
            title: "선물 퍼트리기",
            action: #selector(scatterBoxes),
            keyEquivalent: "s"
        )
        menu.addItem(scatterBoxesMenuItem!)

        menu.addItem(NSMenuItem.separator())

        // Display 모드 선택 (서브메뉴)
        let visibilitySubmenu = NSMenu()

        let allVisibleItem = NSMenuItem(
            title: "Character & Gifts",
            action: #selector(setVisibilityMode(_:)),
            keyEquivalent: ""
        )
        allVisibleItem.tag = 0
        allVisibleItem.state = .on
        visibilityMenuItems[.characterAndBoxes] = allVisibleItem
        visibilitySubmenu.addItem(allVisibleItem)

        let characterOnlyItem = NSMenuItem(
            title: "Character Only",
            action: #selector(setVisibilityMode(_:)),
            keyEquivalent: ""
        )
        characterOnlyItem.tag = 1
        visibilityMenuItems[.characterOnly] = characterOnlyItem
        visibilitySubmenu.addItem(characterOnlyItem)

        let hiddenItem = NSMenuItem(
            title: "Hide All",
            action: #selector(setVisibilityMode(_:)),
            keyEquivalent: ""
        )
        hiddenItem.tag = 2
        visibilityMenuItems[.hidden] = hiddenItem
        visibilitySubmenu.addItem(hiddenItem)

        let visibilityMenuItem = NSMenuItem(title: "Display", action: nil, keyEquivalent: "")
        visibilityMenuItem.submenu = visibilitySubmenu
        menu.addItem(visibilityMenuItem)

        menu.addItem(NSMenuItem.separator())

        // 앱 정보
        menu.addItem(
            NSMenuItem(
                title: "Christmas Desktop Buddy v1.0.0",
                action: nil,
                keyEquivalent: ""
            )
        )

        menu.addItem(NSMenuItem.separator())

        // 종료
        menu.addItem(
            NSMenuItem(
                title: "종료",
                action: #selector(NSApplication.terminate(_:)),
                keyEquivalent: "q"
            )
        )

        statusItem?.menu = menu
    }

    @objc private func changeCharacter(_ sender: NSMenuItem) {
        let type = CharacterType.allCases[sender.tag]
        characterWindow?.changeCharacter(to: type)
        print("✨ 캐릭터 변경: \(type.displayName)")
    }

    @objc private func setVisibilityMode(_ sender: NSMenuItem) {
        // tag로 모드 결정
        let mode: VisibilityMode
        switch sender.tag {
        case 0:
            mode = .characterAndBoxes
        case 1:
            mode = .characterOnly
        case 2:
            mode = .hidden
        default:
            return
        }

        currentVisibilityMode = mode
        updateVisibility()
        updateVisibilityMenuSelection()
    }

    private func updateVisibility() {
        guard let characterWin = characterWindow else { return }

        switch currentVisibilityMode {
        case .characterAndBoxes:
            // 캐릭터와 상자 모두 표시
            characterWin.makeKeyAndOrderFront(nil)
            boxWindows.forEach { $0.makeKeyAndOrderFront(nil) }
            scatterBoxesMenuItem?.isEnabled = true
            print("👀 캐릭터와 상자 모두 표시")

        case .characterOnly:
            // 캐릭터만 표시
            characterWin.makeKeyAndOrderFront(nil)
            boxWindows.forEach { $0.orderOut(nil) }
            scatterBoxesMenuItem?.isEnabled = false
            print("👤 캐릭터만 표시")

        case .hidden:
            // 모두 숨김
            characterWin.orderOut(nil)
            boxWindows.forEach { $0.orderOut(nil) }
            scatterBoxesMenuItem?.isEnabled = false
            print("👻 모두 숨김")
        }
    }

    private func updateVisibilityMenuSelection() {
        // 모든 메뉴 아이템의 체크 해제
        visibilityMenuItems.values.forEach { $0.state = .off }
        // 현재 모드만 체크
        visibilityMenuItems[currentVisibilityMode]?.state = .on
    }

    @objc private func scatterBoxes() {
        // 상자가 보이는 상태일 때만 실행
        guard currentVisibilityMode == .characterAndBoxes else {
            print("⚠️ 상자가 보이지 않는 상태에서는 퍼트릴 수 없습니다")
            return
        }

        boxManager?.scatterBoxes()
        print("🎁 선물 상자를 퍼트렸습니다!")
    }

    /// 메뉴바 아이콘 이미지 로드
    private func loadMenuBarImages() {
        for i in 1...6 {
            if let url = Bundle.module.url(forResource: "menubar-tree-\(i)", withExtension: "svg"),
               let image = NSImage(contentsOf: url) {
                // 메뉴바에 맞는 크기로 설정
                image.size = NSSize(width: 18, height: 18)
                menuBarImages.append(image)
            }
        }

        // 이미지 로드 실패 시 기본 이모지 사용
        if menuBarImages.isEmpty {
            print("⚠️ 메뉴바 아이콘 이미지 로드 실패")
        } else {
            print("✅ 메뉴바 아이콘 이미지 \(menuBarImages.count)개 로드 완료")
        }
    }

    /// 메뉴바 아이콘 애니메이션 시작
    private func startMenuBarAnimation() {
        guard !menuBarImages.isEmpty else {
            // 이미지가 없으면 기본 이모지 사용
            statusItem?.button?.title = "🎄"
            return
        }

        let timer = Timer(timeInterval: 0.3, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.menuBarFrameIndex = (self.menuBarFrameIndex + 1) % self.menuBarImages.count
            self.statusItem?.button?.image = self.menuBarImages[self.menuBarFrameIndex]
        }
        // 메뉴가 열려있어도 애니메이션이 계속 실행되도록 common 모드에 추가
        RunLoop.main.add(timer, forMode: .common)
        menuBarAnimationTimer = timer
    }
}
