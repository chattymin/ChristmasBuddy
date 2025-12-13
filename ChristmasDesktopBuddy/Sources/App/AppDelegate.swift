import Cocoa
import SwiftUI

/// 앱 델리게이트
class AppDelegate: NSObject, NSApplicationDelegate {
    private var characterWindow: CharacterWindow?
    private var statusItem: NSStatusItem?
    private var toggleWindowMenuItem: NSMenuItem?
    private var boxManager: BoxManager?
    private var boxWindows: [BoxWindow] = []

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

        // Dock 아이콘 숨기기 (옵션)
        NSApp.setActivationPolicy(.accessory)
    }

    /// 상자 윈도우들 생성
    private func setupBoxWindows() {
        guard let manager = boxManager else { return }

        boxWindows = manager.boxes.map { box in
            let window = BoxWindow(box: box, boxManager: manager)
            window.makeKeyAndOrderFront(nil)
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
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem?.button {
            button.title = "🎄"
        }

        let menu = NSMenu()

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

        // 캐릭터 표시/숨기기 (토글)
        toggleWindowMenuItem = NSMenuItem(
            title: "Visible: ✓ On",
            action: #selector(toggleWindow),
            keyEquivalent: "h"
        )
        menu.addItem(toggleWindowMenuItem!)

        menu.addItem(NSMenuItem.separator())

        // 앱 정보
        menu.addItem(
            NSMenuItem(
                title: "Christmas Desktop Buddy v1.0",
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

    @objc private func toggleWindow() {
        guard let window = characterWindow else { return }

        if window.isVisible {
            // 캐릭터 숨기기
            window.orderOut(nil)
            toggleWindowMenuItem?.title = "Visible: ✗ Off"
            print("👻 캐릭터 숨김")
        } else {
            // 캐릭터 표시
            window.makeKeyAndOrderFront(nil)
            toggleWindowMenuItem?.title = "Visible: ✓ On"
            print("👀 캐릭터 표시")
        }
    }
}
