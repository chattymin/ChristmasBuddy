import Foundation

/// 시간 정보 제공자
class TimeProvider: InfoProvider {
    var icon: String { "⏰" }
    var title: String { "현재 시간" }
    var priority: Int { 2 }

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()

    func getValue() async -> String {
        return dateFormatter.string(from: Date())
    }
}
