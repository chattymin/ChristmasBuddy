import Cocoa

/// 앱 진입점
@main
struct ChristmasBuddyApp {
    static func main() {
        let app = NSApplication.shared
        let delegate = AppDelegate()
        app.delegate = delegate
        app.run()
    }
}
