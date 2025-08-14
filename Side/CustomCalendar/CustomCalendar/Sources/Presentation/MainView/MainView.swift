import SwiftUI
import SwiftData


struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var mainViewModel = MainViewModel()
    @State private var isEditDashboard: Bool = false
    
    var body: some View {
        VStack {
            setupMainView()
            setupWidgetDashboard()
            Spacer()
        }
    }
    
    //MARK: setup
    private func setupMainView() -> some View {
        HStack {
            setupHeader()
        }
        .onAppear {
            mainViewModel.attachContext(modelContext)
        }
        .padding()
    }
    
    private func setupHeader() -> some View {
        HStack {
            Text("My Schedule")
                .font(.largeTitle).bold()
            Spacer()
            
            //TODO: 이 부분은 나중에 widget을 선택할 창으로 대체할 예정 임시용임
            Menu {
                Button("Calendar 추가") {
                    mainViewModel.addWidget(kind: .calendar)
                }
                Button("TODO 추가") {
                    mainViewModel.addWidget(kind: .todo)
                }
                Button("Memo 추가") {
                    mainViewModel.addWidget(kind: .memo)
                }
            } label: {
                Label("Add", systemImage: "plus.circle")
                    .font(.title2)
            }
            .padding(.trailing, 8)
            
            Button { isEditDashboard.toggle() } label: {
                Image(systemName: isEditDashboard ? "checkmark.circle.fill" : "pencil.circle")
                    .font(.title)
            }
        }
        .padding(.horizontal)
    }
    
    private func setupWidgetDashboard() -> some View {
        WidgetDashboardView(isEditing: $isEditDashboard)
            .padding(.horizontal)
    }
}

#Preview {
    MainView()
}
