import Foundation

/// 정보 아이템 모델
struct InfoItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let value: String
    let priority: Int

    init(icon: String, title: String, value: String, priority: Int = 5) {
        self.icon = icon
        self.title = title
        self.value = value
        self.priority = priority
    }
}
