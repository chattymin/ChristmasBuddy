import Foundation
import AppKit

/// 선물 상자 모델
struct Box: Identifiable {
    let id: UUID
    var position: CGPoint
    var isInOriginalPosition: Bool

    init(id: UUID = UUID(), position: CGPoint, isInOriginalPosition: Bool = true) {
        self.id = id
        self.position = position
        self.isInOriginalPosition = isInOriginalPosition
    }
}
