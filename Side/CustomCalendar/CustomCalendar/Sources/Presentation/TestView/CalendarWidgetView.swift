import SwiftUI

struct CalendarWidgetView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Calendar").font(.headline)
            Text("Aug 2025").font(.subheadline).foregroundStyle(.secondary)
            Spacer(minLength: 8)
            RoundedRectangle(cornerRadius: 8).fill(.white.opacity(0.6)).frame(height: 50)
        }
    }
}
