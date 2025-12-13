import Foundation
import AppKit

/// 선물 상자 관리자
class BoxManager: ObservableObject {
    @Published var boxes: [Box] = []

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
            boxes[index].position = position
            boxes[index].isInOriginalPosition = isPositionOriginal(position, stackIndex: index)
        }
    }

    /// 흩어진 상자들 가져오기
    func getScatteredBoxes() -> [Box] {
        return boxes.filter { !$0.isInOriginalPosition }
    }

    /// 원래 위치인지 확인
    private func isPositionOriginal(_ position: CGPoint, stackIndex: Int) -> Bool {
        let yOffset = CGFloat(stackIndex) * (boxSize + stackSpacing)
        let originalPos = CGPoint(
            x: originalStackPosition.x,
            y: originalStackPosition.y + yOffset
        )
        let threshold: CGFloat = 10
        return abs(position.x - originalPos.x) < threshold &&
               abs(position.y - originalPos.y) < threshold
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
        }
    }
}
