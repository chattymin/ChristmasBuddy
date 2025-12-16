import Foundation
import AppKit

/// 선물 상자 관리자
class BoxManager: ObservableObject {
    @Published var boxes: [Box] = []
    var boxWindows: [UUID: BoxWindow] = [:]

    private let originalStackPosition: CGPoint
    private let boxSize: CGFloat = 48
    private let stackSpacing: CGFloat = 4

    init() {
        // 화면 오른쪽 하단에 상자 쌓기
        if let screen = NSScreen.main {
            let screenFrame = screen.visibleFrame
            self.originalStackPosition = CGPoint(
                x: screenFrame.maxX - boxSize - 20,
                y: screenFrame.minY + 20
            )
        } else {
            self.originalStackPosition = CGPoint(x: 100, y: 100)
        }

        createBoxes()
    }

    /// 랜덤 개수(5-8개)의 상자 생성
    private func createBoxes() {
        let count = Int.random(in: 5...8)
        boxes = (0..<count).map { index in
            let yOffset = CGFloat(index) * (boxSize + stackSpacing)
            let position = CGPoint(
                x: originalStackPosition.x,
                y: originalStackPosition.y + yOffset
            )
            return Box(position: position, isInOriginalPosition: true)
        }
    }

    /// 상자 위치 업데이트
    func updateBoxPosition(id: UUID, to position: CGPoint) {
        if let index = boxes.firstIndex(where: { $0.id == id }) {
            let wasOriginal = boxes[index].isInOriginalPosition
            boxes[index].position = position
            boxes[index].isInOriginalPosition = isPositionOriginal(position, stackIndex: index)

            // 상태 변경 시 로그
            if wasOriginal && !boxes[index].isInOriginalPosition {
                print("📍 상자 \(index)번이 흩어졌습니다! 위치: \(position)")
            }
        }
    }

    /// 흩어진 상자들 가져오기
    func getScatteredBoxes() -> [Box] {
        let scattered = boxes.filter { !$0.isInOriginalPosition }
        if !scattered.isEmpty {
            print("🔍 흩어진 상자 \(scattered.count)개 발견!")
        }
        return scattered
    }

    /// 원래 위치인지 확인
    private func isPositionOriginal(_ position: CGPoint, stackIndex: Int) -> Bool {
        let yOffset = CGFloat(stackIndex) * (boxSize + stackSpacing)
        let originalPos = CGPoint(
            x: originalStackPosition.x,
            y: originalStackPosition.y + yOffset
        )
        let threshold: CGFloat = 30  // 임계값을 30으로 증가
        let isOriginal = abs(position.x - originalPos.x) < threshold &&
               abs(position.y - originalPos.y) < threshold

        if !isOriginal {
            print("  상자 \(stackIndex): 현재=(\(Int(position.x)), \(Int(position.y))) vs 원위치=(\(Int(originalPos.x)), \(Int(originalPos.y)))")
        }

        return isOriginal
    }

    /// 상자를 원래 위치로 되돌리기
    func returnBoxToOriginalPosition(id: UUID) {
        if let index = boxes.firstIndex(where: { $0.id == id }) {
            let yOffset = CGFloat(index) * (boxSize + stackSpacing)
            let originalPos = CGPoint(
                x: originalStackPosition.x,
                y: originalStackPosition.y + yOffset
            )
            boxes[index].position = originalPos
            boxes[index].isInOriginalPosition = true

            // 윈도우도 실제로 이동
            if let window = boxWindows[id] {
                window.setFrameOrigin(originalPos)
            }

            print("📦 상자 \(index) 원위치로 복귀: \(originalPos)")
        }
    }

    /// 모든 상자를 랜덤한 위치로 퍼트리기
    func scatterBoxes() {
        guard let screen = NSScreen.main else { return }
        let screenFrame = screen.visibleFrame

        print("🎲 상자를 퍼트립니다!")

        for box in boxes {
            // 화면 내 랜덤 위치 생성 (여백 100px)
            let randomX = CGFloat.random(in: (screenFrame.minX + 100)...(screenFrame.maxX - 100))
            let randomY = CGFloat.random(in: (screenFrame.minY + 100)...(screenFrame.maxY - 100))
            let randomPosition = CGPoint(x: randomX, y: randomY)

            // 상자 위치 업데이트
            updateBoxPosition(id: box.id, to: randomPosition)

            // 윈도우도 실제로 이동
            if let window = boxWindows[box.id] {
                window.setFrameOrigin(randomPosition)
            }
        }

        print("🎁 \(boxes.count)개의 상자가 퍼트려졌습니다!")
    }
}
