import SwiftUI

struct MemoWidgetView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Memo").font(.headline)
            Text("회의 요약: 다음 스프린트 목표 확정…")
                .font(.subheadline)
                .lineLimit(3)
        }
    }
}
