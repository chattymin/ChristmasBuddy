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

    var dizzySvgFileName: String {
        return "\(rawValue)-dizzy.svg"
    }

    /// 아이들 애니메이션 프레임 파일명 배열
    var idleFrameFileNames: [String] {
        return [
            "\(rawValue)-idle-1.svg",
            "\(rawValue)-idle-2.svg",
            "\(rawValue)-idle-3.svg"
        ]
    }

    /// 특정 아이들 프레임 파일명
    func idleFrameFileName(index: Int) -> String {
        let frames = idleFrameFileNames
        let safeIndex = index % frames.count
        return frames[safeIndex]
    }
}
