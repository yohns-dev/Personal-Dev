import Foundation
import SwiftData

@MainActor
final class MainViewModel: ObservableObject {
    private(set) var modelContext: ModelContext?
    
    func attachContext(_ modelContext: ModelContext) { self.modelContext = modelContext
    }

}
