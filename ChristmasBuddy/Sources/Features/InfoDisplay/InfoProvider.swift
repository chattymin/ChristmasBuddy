import Foundation

/// InfoProvider 프로토콜 - 확장 가능한 정보 제공 인터페이스
/// Phase 2에서 새로운 Provider를 추가할 때 이 프로토콜을 구현하면 됩니다
protocol InfoProvider {
    /// 아이콘 (이모지)
    var icon: String { get }

    /// 제목
    var title: String { get }

    /// 우선순위 (낮을수록 먼저 표시)
    var priority: Int { get }

    /// 비동기로 값 가져오기
    func getValue() async -> String
}

extension InfoProvider {
    /// InfoItem으로 변환
    func getInfoItem() async -> InfoItem {
        let value = await getValue()
        return InfoItem(
            icon: icon,
            title: title,
            value: value,
            priority: priority
        )
    }
}
