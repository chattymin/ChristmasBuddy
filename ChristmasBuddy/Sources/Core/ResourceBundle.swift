import Foundation

/// 앱의 리소스 번들을 찾는 유틸리티
enum ResourceBundle {
    /// 리소스 번들 (앱 번들 또는 SwiftPM 번들)
    static var bundle: Bundle = {
        // 1. 먼저 앱 번들 내부의 리소스 번들 확인
        if let appBundle = Bundle.main.url(forResource: "ChristmasBuddy_ChristmasBuddy", withExtension: "bundle"),
           let resourceBundle = Bundle(url: appBundle) {
            print("📦 앱 번들 내 리소스 번들 사용: \(appBundle.path)")
            return resourceBundle
        }

        // 2. SwiftPM Bundle.module 사용 (개발 중)
        print("📦 SwiftPM Bundle.module 사용")
        return Bundle.module
    }()
}
