import Foundation
import AppKit

/// 화면 변경 감지 및 알림을 관리하는 매니저
class ScreenChangeManager {
    static let shared = ScreenChangeManager()

    /// 화면 변경 시 호출되는 콜백
    var onScreenChange: (() -> Void)?

    /// 마지막으로 감지된 화면 구성 (변경 여부 판단용)
    private var lastScreenConfiguration: [CGDirectDisplayID: NSRect] = [:]

    private init() {
        // 초기 화면 구성 저장
        updateScreenConfiguration()

        // 화면 변경 알림 구독
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleScreenChange),
            name: NSApplication.didChangeScreenParametersNotification,
            object: nil
        )

        print("🖥️ ScreenChangeManager 초기화 완료")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    /// 현재 화면 구성 저장
    private func updateScreenConfiguration() {
        lastScreenConfiguration = [:]
        for screen in NSScreen.screens {
            if let displayID = screen.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? CGDirectDisplayID {
                lastScreenConfiguration[displayID] = screen.frame
            }
        }
    }

    /// 화면 변경 핸들러
    @objc private func handleScreenChange() {
        print("🖥️ 화면 구성 변경 감지!")

        // 새 화면 구성 확인
        var newConfiguration: [CGDirectDisplayID: NSRect] = [:]
        for screen in NSScreen.screens {
            if let displayID = screen.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? CGDirectDisplayID {
                newConfiguration[displayID] = screen.frame
            }
        }

        // 실제로 변경되었는지 확인
        let hasChanges = hasSignificantChanges(from: lastScreenConfiguration, to: newConfiguration)

        if hasChanges {
            print("🖥️ 화면 해상도/구성 변경 확인됨")
            print("   화면 수: \(lastScreenConfiguration.count) → \(newConfiguration.count)")

            // 구성 업데이트
            lastScreenConfiguration = newConfiguration

            // 약간의 지연 후 콜백 호출 (화면 전환이 완전히 완료되도록)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.onScreenChange?()
            }
        }
    }

    /// 유의미한 변경인지 확인
    private func hasSignificantChanges(
        from old: [CGDirectDisplayID: NSRect],
        to new: [CGDirectDisplayID: NSRect]
    ) -> Bool {
        // 화면 수가 다르면 변경
        if old.count != new.count {
            return true
        }

        // 각 화면의 해상도/위치 확인
        for (displayID, newFrame) in new {
            if let oldFrame = old[displayID] {
                // 해상도나 위치가 10픽셀 이상 다르면 변경으로 간주
                if abs(oldFrame.width - newFrame.width) > 10 ||
                   abs(oldFrame.height - newFrame.height) > 10 ||
                   abs(oldFrame.origin.x - newFrame.origin.x) > 10 ||
                   abs(oldFrame.origin.y - newFrame.origin.y) > 10 {
                    return true
                }
            } else {
                // 새로운 화면이 추가됨
                return true
            }
        }

        return false
    }

    /// 강제로 화면 변경 핸들러 실행 (수동 리셋용)
    func forceRefresh() {
        print("🔄 화면 구성 강제 새로고침")
        updateScreenConfiguration()
        onScreenChange?()
    }
}
