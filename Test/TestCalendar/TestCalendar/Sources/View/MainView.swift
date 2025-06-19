import SwiftUI

struct MainView: View {
    @State private var items = ["🍎", "🍌", "🍇", "🍓", "🍍"]
    @State private var draggingItem: String?
    @GestureState private var dragOffset: CGSize = .zero

    var body: some View {
        Text("")
    }
}

#Preview {
    MainView()
}
