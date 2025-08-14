import SwiftUI
import SwiftData

@main
struct CustomCalendarApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(for: WidgetItem.self)
    }
}
