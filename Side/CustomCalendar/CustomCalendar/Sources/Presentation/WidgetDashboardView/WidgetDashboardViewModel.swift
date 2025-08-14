import Foundation

final class WidgetDashboardViewModel: ObservableObject {
    //TODO: widget은 컴바인으로 관리하게 만들기
    
    @Published var activeWidgetID: UUID? = nil
    
    let rows: Int
    let cols: Int
    
    //TODO: 현재 사이즈에 따라 row, col 값을 바꿀 수 있도록 변경 및 기획 필요
    init(rows: Int = 4, cols: Int = 4) {
        self.rows = rows
        self.cols = cols
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
    
    func isFree(_ rect: WidgetGridRect, in widgets: [WidgetItem], excluding widgetID: UUID? = nil) -> Bool {
        guard isInside(rect) else { return false }
        for w in widgets {
            if let ex = widgetID, ex == w.id { continue }
            if overlaps(rect, w.rect) { return false }
        }
        return true
    }
    
    func tentativeValidRect(for id: UUID, candidate: WidgetGridRect, widgets: [WidgetItem]) -> (WidgetGridRect, Bool) {
        let result = isFree(candidate, in: widgets,excluding: id)
        return (candidate, result)
    }
    
    func researchFreeRect(rowSpan: Int, colSpan: Int, widgets: [WidgetItem]) -> WidgetGridRect? {
        guard rowSpan > 0, colSpan > 0,
                rowSpan <= rows,
                colSpan <= cols
        else { return nil }
        
        for rect in 0...(rows - rowSpan) {
            for col in 0...(cols - colSpan) {
                let candidate = WidgetGridRect(row: rect, col: col, rowSpan: rowSpan, colSpan: colSpan)
                if isFree(candidate, in: widgets) { return candidate }
            }
        }
        return nil
    }
}
