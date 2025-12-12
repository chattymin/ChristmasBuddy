import Foundation

/// 랜덤 메시지 생성기
class MessageGenerator {
    private let messages: [String]

    init() {
        // 시간대별 멘트
        self.messages = [
            // 오전
            "좋은 아침이에요! ☕",
            "오늘도 화이팅! 💪",
            "새로운 하루의 시작! 🌅",

            // 오후
            "점심 드셨어요? 🍱",
            "오후에도 힘내세요! 🌟",
            "커피 한 잔 어때요? ☕",

            // 저녁
            "아직 퇴근은 아닌 것 같아요... ⛄",
            "조금만 더 힘내요! 🎄",
            "오늘도 고생 많으셨어요! 🌙",

            // 일반
            "메리 크리스마스! 🎅",
            "행복한 하루 되세요! ⭐",
            "당신은 잘하고 있어요! 💝",
            "화이팅! 🎁",
            "잠깐 쉬어가세요~ 🎄",
        ]
    }

    /// 현재 시간대에 맞는 랜덤 메시지 반환
    func getRandomMessage() -> String {
        let hour = Calendar.current.component(.hour, from: Date())

        // 시간대별 필터링
        let timeBasedMessages: [String]
        switch hour {
        case 6..<12:
            timeBasedMessages = messages.filter { $0.contains("아침") || $0.contains("시작") }
        case 12..<14:
            timeBasedMessages = messages.filter { $0.contains("점심") }
        case 18..<24:
            timeBasedMessages = messages.filter { $0.contains("퇴근") || $0.contains("고생") }
        default:
            timeBasedMessages = []
        }

        // 시간대별 메시지가 있으면 그 중에서, 없으면 전체에서 랜덤 선택
        let pool = timeBasedMessages.isEmpty ? messages : (timeBasedMessages + messages)
        return pool.randomElement() ?? "메리 크리스마스! 🎅"
    }

    /// 배터리 상태에 따른 메시지
    func getBatteryMessage(level: Int) -> String? {
        if level < 20 {
            return "충전이 필요해요! 🔌"
        } else if level == 100 {
            return "배터리 완충! 🎉"
        }
        return nil
    }
}
