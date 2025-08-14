import Foundation
import SwiftData

@MainActor
final class MainViewModel: ObservableObject {
    private(set) var modelContext: ModelContext?
    
    func attachContext(_ modelContext: ModelContext) { self.modelContext = modelContext
    }
    
    //MARK: Widget
    func addWidget(kind: WidgetKind) {
        guard let modelContext else { return }
        let item = WidgetItem(kind: kind, title: kind.rawValue)
        print(item)
        modelContext.insert(item)
        try? modelContext.save()
    }
    
    func removeWidget(id: UUID) {
        guard let modelContext else { return }
        let desc = FetchDescriptor<WidgetItem>()
        if let all = try? modelContext.fetch(desc),
           let target = all.first(where: { $0.id == id }) {
            modelContext.delete(target)
            try? modelContext.save()
        }
    }
}
