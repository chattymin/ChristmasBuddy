import Foundation
import Combine

/// 랜덤 인사 기능 관리자
class RandomGreetingManager: ObservableObject {
    static let shared = RandomGreetingManager()

    @Published var isEnabled: Bool = true
    @Published var shouldShowGreeting: Bool = false
    @Published var greetingMessage: String = ""

    private var greetingTimer: Timer?
    private let messageGenerator = MessageGenerator()

    // 타이머 간격: 15분 ~ 30분 (초 단위)
    private let minInterval: TimeInterval = 15 * 60  // 15분
    private let maxInterval: TimeInterval = 30 * 60  // 30분

    private init() {}

    /// 랜덤 인사 타이머 시작
    func startTimer() {
        stopTimer()
        guard isEnabled else { return }
        scheduleNextGreeting()
    }

    /// 타이머 중지
    func stopTimer() {
        greetingTimer?.invalidate()
        greetingTimer = nil
    }

    /// 다음 인사 예약
    private func scheduleNextGreeting() {
        let randomInterval = TimeInterval.random(in: minInterval...maxInterval)
        print("⏰ 다음 인사까지 \(Int(randomInterval / 60))분 \(Int(randomInterval.truncatingRemainder(dividingBy: 60)))초")

        greetingTimer = Timer.scheduledTimer(withTimeInterval: randomInterval, repeats: false) { [weak self] _ in
            self?.showGreeting()
        }

        // 메뉴가 열려있어도 타이머 동작하도록
        if let timer = greetingTimer {
            RunLoop.main.add(timer, forMode: .common)
        }
    }

    /// 인사 표시
    private func showGreeting() {
        guard isEnabled else {
            scheduleNextGreeting()
            return
        }

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.greetingMessage = self.messageGenerator.getRandomMessage()
            self.shouldShowGreeting = true
            print("💬 랜덤 인사: \(self.greetingMessage)")
        }

        // 다음 인사 예약
        scheduleNextGreeting()
    }

    /// 인사 숨기기
    func hideGreeting() {
        DispatchQueue.main.async { [weak self] in
            self?.shouldShowGreeting = false
        }
    }

    /// 활성화/비활성화 토글
    func toggle() {
        isEnabled.toggle()
        if isEnabled {
            startTimer()
        } else {
            stopTimer()
            hideGreeting()
        }
        print("🔔 랜덤 인사 기능: \(isEnabled ? "켜짐" : "꺼짐")")
    }
}
