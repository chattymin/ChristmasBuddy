import Foundation

enum CharacterType: String, CaseIterable {
    case snowman
    case santa
    case reindeer

    var displayName: String {
        switch self {
        case .snowman:
            return "눈사람 ⛄"
        case .santa:
            return "산타 🎅"
        case .reindeer:
            return "루돌프 🦌"
        }
    }

    var svgFileName: String {
        return "\(rawValue).svg"
    }
}
