import Foundation
import SwiftData
import Combine

@MainActor
final class WidgetDashboardViewModel: ObservableObject {
    @Published private(set) var widgets: [WidgetItem] = []
    @Published var activeWidgetID: UUID? = nil
    
    private var modelContext: ModelContext?
    private var cancellable: AnyCancellable?
    
    let rows: Int
    let cols: Int
    
    init(rows: Int = 8, cols: Int = 8) {
        self.rows = rows
        self.cols = cols
    }
    
    deinit {
        cancellable?.cancel()
    }
    
    // MARK: - Context & Auto-refresh
    func attachModelContext(_ modelContext: ModelContext) {
        self.modelContext = modelContext
        cancellable?.cancel()
        
        let container = modelContext.container
        cancellable = NotificationCenter.default
            .publisher(for: ModelContext.didSave, object: nil)
            .compactMap { $0.object as? ModelContext }
            .filter { $0.container === container }
            .debounce(for: .milliseconds(120), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.loadWidgets()
            }
    }
    
    func loadWidgets() {
        guard let modelContext else { return }
        let desc = FetchDescriptor<WidgetItem>(
            sortBy: [SortDescriptor(\.createdAt, order: .forward)]
        )
        widgets = (try? modelContext.fetch(desc)) ?? []
        assignRectForNewWidget()
    }
    
    // MARK: - CRUD
    func addWidget(kind: WidgetKind) {
        guard let modelContext else { return }
        let item = WidgetItem(kind: kind, title: kind.rawValue)
        modelContext.insert(item)
        try? modelContext.save()
        assignRect(item)
        loadWidgets()
    }
    
    func removeWidgets(ids: [UUID]) {
        guard let modelContext, !ids.isEmpty else { return }
        let desc = FetchDescriptor<WidgetItem>()
        guard let all = try? modelContext.fetch(desc) else { return }

        for id in ids {
            if let target = all.first(where: { $0.id == id }) {
                modelContext.delete(target)
            }
        }
        try? modelContext.save()
        
        if let active = activeWidgetID, ids.contains(active) {
            activeWidgetID = nil
        }
        loadWidgets()
    }
    
    // MARK: - Placement helpers
    private func assignRectForNewWidget() {
        for widget in widgets where widget.rect == nil {
            assignRect(widget)
        }
    }
    
    private func assignRect(_ item: WidgetItem) {
        guard let modelContext, item.rect == nil else { return }
        if let emptyRect = researchFreeRect(rowSpan: 1, colSpan: 1, widgets: widgets) {
            item.rect = emptyRect
            try? modelContext.save()
            objectWillChange.send()
        }
    }
    
    // MARK: - Move/Resize Validation & Commit
    func tentativeValidRect(for id: UUID, candidate: WidgetGridRect) -> (WidgetGridRect, Bool) {
        let result = isFree(candidate, in: widgets, excluding: id)
        return (candidate, result)
    }
    
    @discardableResult
    func commitMove(id: UUID, to rect: WidgetGridRect) -> Bool {
        guard let modelContext else { return false }
        guard let item = widgets.first(where: { $0.id == id }) else { return false }
        guard isFree(rect, in: widgets, excluding: id) else { return false }
        item.rect = rect
        try? modelContext.save()
        objectWillChange.send()
        return true
    }
    
    // MARK: - Rules
    func isInside(_ rect: WidgetGridRect) -> Bool {
        rect.row >= 0 &&
        rect.col >= 0 &&
        rect.row + rect.rowSpan <= rows &&
        rect.col + rect.colSpan <= cols &&
        rect.rowSpan > 0 &&
        rect.colSpan > 0
    }
    
    func overlaps(_ a: WidgetGridRect, _ b: WidgetGridRect) -> Bool {
        !(a.row + a.rowSpan <= b.row ||
          b.row + b.rowSpan <= a.row ||
          a.col + a.colSpan <= b.col ||
          b.col + b.colSpan <= a.col)
    }
    
    func isFree(_ rect: WidgetGridRect, in widgets: [WidgetItem], excluding widgetID: UUID? = nil) -> Bool {
        guard isInside(rect) else { return false }
        for widget in widgets {
            if let excludingID = widgetID, widget.id == excludingID { continue }
            guard let other = widget.rect else { continue }
            if overlaps(rect, other) { return false }
        }
        return true
    }
    
    func researchFreeRect(rowSpan: Int, colSpan: Int, widgets: [WidgetItem]) -> WidgetGridRect? {
        guard rowSpan > 0, colSpan > 0,
              rowSpan <= rows, colSpan <= cols
        else { return nil }
        
        for row in 0...(rows - rowSpan) {
            for col in 0...(cols - colSpan) {
                let candidate = WidgetGridRect(row: row, col: col, rowSpan: rowSpan, colSpan: colSpan)
                if isFree(candidate, in: widgets) { return candidate }
            }
        }
        return nil
    }
}
