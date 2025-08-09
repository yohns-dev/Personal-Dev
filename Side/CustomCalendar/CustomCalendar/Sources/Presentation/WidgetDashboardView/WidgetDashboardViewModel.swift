import Foundation

final class WidgetDashboardViewModel: ObservableObject {
    //TODO: widget은 컴바인으로 관리하게 만들기
    
    @Published var widgets: [WidgetItem]
    @Published var activeWidgetID: UUID? // new
    
    let rows: Int
    let cols: Int
    
    //TODO: 현재 사이즈에 따라 row, col 값을 바꿀 수 있도록 변경 및 기획 필요
    init(rows: Int = 4, cols: Int = 4, widgets: [WidgetItem]) {
        self.rows = rows
        self.cols = cols
        self.widgets = widgets
    }
    
    //MARK: Utility
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
    
    func isFree(_ rect: WidgetGridRect, excluding widgetID: UUID? = nil) -> Bool {
        guard isInside(rect) else { return false }
        for w in widgets {
            if let ex = widgetID, ex == w.id { continue }
            if overlaps(rect, w.rect) { return false }
        }
        return true
    }
    
    func tryMove(_ id: UUID, to rect: WidgetGridRect) -> Bool {
        guard isFree(rect, excluding: id) else { return false }
        if let idx = widgets.firstIndex(where: { $0.id == id }) {
            widgets[idx].rect = rect
            return true
        }
        return false
    }
    
    func tentativeValidRect(for id: UUID, candidate: WidgetGridRect) -> (WidgetGridRect, Bool) {
        let ok = isFree(candidate, excluding: id)
        return (candidate, ok)
    }
}
