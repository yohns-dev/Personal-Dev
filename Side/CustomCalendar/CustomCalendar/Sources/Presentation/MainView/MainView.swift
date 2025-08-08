import SwiftUI


struct MainView: View {
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
            Text("My Schedule")
                .font(.largeTitle)
                .bold()
            
            Spacer()
            
            Button(action: { isEditDashboard.toggle() }) {
                Image(systemName: isEditDashboard ? "checkmark.circle.fill" : "pencil.circle")
                    .font(.title)
            }
        }
        .padding()
    }
    
    private func setupWidgetDashboard() -> some View {
        WidgetDashboardView()
            .padding(.horizontal)
    }
}

#Preview {
    MainView()
}
