import SwiftUI

/// 랜덤 인사 말풍선 뷰
struct RandomGreetingBubbleView: View {
    let message: String

    var body: some View {
        VStack(spacing: 0) {
            // 말풍선 본체
            Text(message)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(NSColor.windowBackgroundColor))
                        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                )

            // 말풍선 꼬리
            Triangle()
                .fill(Color(NSColor.windowBackgroundColor))
                .frame(width: 16, height: 10)
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
        }
    }
}

/// 말풍선 꼬리용 삼각형
private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}
