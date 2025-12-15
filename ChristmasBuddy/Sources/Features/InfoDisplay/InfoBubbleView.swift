import SwiftUI

/// 정보를 표시하는 말풍선 뷰
struct InfoBubbleView: View {
    let items: [InfoItem]
    let message: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 정보 아이템들
            ForEach(items.sorted(by: { $0.priority < $1.priority })) { item in
                HStack(spacing: 6) {
                    Text(item.icon)
                        .font(.system(size: 14))

                    Text(item.title + ":")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)

                    Text(item.value)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.primary)

                    Spacer()
                }
            }

            // 구분선
            Divider()
                .padding(.vertical, 2)

            // 랜덤 멘트
            HStack {
                Text("💬")
                    .font(.system(size: 14))

                Text(message)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(nsColor: .windowBackgroundColor))
                .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
        .frame(width: 220)
    }
}

// Preview
struct InfoBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        InfoBubbleView(
            items: [
                InfoItem(icon: "🔋", title: "배터리", value: "73%", priority: 1),
                InfoItem(icon: "⏰", title: "현재 시간", value: "15:30", priority: 2)
            ],
            message: "아직 퇴근은 아닌 것 같아요... ⛄"
        )
        .padding()
    }
}
