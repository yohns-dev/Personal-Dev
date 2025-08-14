import SwiftUI
import SwiftData


struct MainView: View {
    @Environment(\.modelContext) private var modelContext
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
        .padding()
    }
    
    private func setupHeader() -> some View {
        HStack {
            Text("My Schedule")
                .font(.largeTitle).bold()
            Spacer()
            
            //TODO: 이 부분은 나중에 widget을 선택할 창으로 대체할 예정 임시용임
            Menu {
                Button("Calendar 추가") { addWidget(.calendar) }
                Button("TODO 추가")     { addWidget(.todo) }
                Button("Memo 추가")     { addWidget(.memo) }
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
    
    private func addWidget(_ kind: WidgetKind) {
        let item = WidgetItem(kind: kind, title: kind.rawValue, rect: .init(row: 0, col: 0, rowSpan: 1, colSpan: 1))
        modelContext.insert(item)
        try? modelContext.save()
    }
}

#Preview {
    MainView()
}
