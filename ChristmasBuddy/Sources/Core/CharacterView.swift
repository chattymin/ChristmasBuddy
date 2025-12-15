import SwiftUI

/// 캐릭터를 표시하는 뷰
struct CharacterView: View {
    let characterType: CharacterType
    let size: CGFloat
    var isDizzy: Bool = false
    var facingLeft: Bool = false  // 좌측을 향하는지 여부
    var idleFrameIndex: Int = 0   // 아이들 애니메이션 프레임 인덱스
    @State private var isHovering = false

    var body: some View {
        Group {
            let fileName = getFileName()
            if let svgData = loadSVG(fileName: fileName),
               let nsImage = NSImage(data: svgData) {
                Image(nsImage: nsImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
            } else {
                // SVG 로드 실패 시 폴백 - 이모지 사용
                Text(getEmojiForCharacter(characterType))
                    .font(.system(size: size))
            }
        }
        .scaleEffect(x: facingLeft ? -1 : 1, y: 1)  // 좌우 반전
        .scaleEffect(isHovering ? 1.1 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isHovering)
        .onHover { hovering in
            isHovering = hovering
        }
    }

    /// 현재 표시할 파일명 결정
    private func getFileName() -> String {
        if isDizzy {
            return characterType.dizzySvgFileName
        } else {
            // 아이들 애니메이션 프레임 사용
            return characterType.idleFrameFileName(index: idleFrameIndex)
        }
    }

    /// SVG 파일 로드
    private func loadSVG(fileName: String) -> Data? {
        // ResourceBundle에서 리소스 찾기
        guard let url = ResourceBundle.bundle.url(forResource: fileName.replacingOccurrences(of: ".svg", with: ""), withExtension: "svg") else {
            print("❌ SVG not found: \(fileName)")
            return nil
        }

        return try? Data(contentsOf: url)
    }

    /// 폴백용 이모지
    private func getEmojiForCharacter(_ type: CharacterType) -> String {
        switch type {
        case .snowman:
            return "⛄"
        case .santa:
            return "🎅"
        case .reindeer:
            return "🦌"
        }
    }
}

// Preview
struct CharacterView_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 20) {
            CharacterView(characterType: .snowman, size: 64)
            CharacterView(characterType: .santa, size: 64)
            CharacterView(characterType: .reindeer, size: 64)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
    }
}
