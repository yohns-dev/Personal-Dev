import SwiftUI

struct TodoWidgetView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("To-Do").font(.headline)
            HStack { Circle().frame(width: 6); Text("Write unit tests") }
            HStack { Circle().frame(width: 6); Text("Design review 2pm") }
            Spacer(minLength: 8)
        }
    }
}
