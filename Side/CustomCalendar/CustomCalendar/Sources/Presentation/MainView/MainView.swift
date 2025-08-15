import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var mainViewModel = MainViewModel()

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("My Schedule")
                    .font(.largeTitle).bold()
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 12)
            .padding(.bottom, 8)

            WidgetDashboardView()
                .padding(.horizontal)

            Spacer(minLength: 0)
        }
        .onAppear {
            mainViewModel.attachContext(modelContext)
        }
    }
}

#Preview {
    MainView()
        .modelContainer(for: WidgetItem.self, inMemory: true)
}
