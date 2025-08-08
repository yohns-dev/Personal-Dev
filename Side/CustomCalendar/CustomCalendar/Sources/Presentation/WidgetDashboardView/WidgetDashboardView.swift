import SwiftUI


struct WidgetDashboardView: View {
    @StateObject private var engine = WidgetDashboardEngine(
        widgets: [
            WidgetItem(id: UUID(), title: "Calendar", rect: .init(row: 0, col: 0, rowSpan: 2, colSpan: 2)),
            WidgetItem(id: UUID(), title: "TODO", rect: .init(row: 0, col: 2, rowSpan: 1, colSpan: 2)),
            WidgetItem(id: UUID(), title: "Memo", rect: .init(row: 2, col: 0, rowSpan: 2, colSpan: 3))
        ]
    )
    
    var body: some View {
        GeometryReader { geo in
            let cellSize = CGSize(width: geo.size.width / CGFloat(engine.cols),
                                  height: geo.size.height / CGFloat(engine.rows))
            ZStack {
                gridBackground(rows: engine.rows, cols: engine.cols, cellSize: cellSize)
                ForEach(engine.widgets) { widget in
                    WidgetView(widget: widget,
                                 cellSize: cellSize,
                                 rows: engine.rows,
                                 cols: engine.cols) { updatedRect in
                        engine.tentativeValidRect(for: widget.id, candidate: updatedRect)
                    } onCommit: { finalRect in
                        _ = engine.tryMove(widget.id, to: finalRect)
                    }
                }
            }
            .padding(12)
        }
    }
    
    @ViewBuilder
    private func gridBackground(rows: Int, cols: Int, cellSize: CGSize) -> some View {
        let totalSize = CGSize(width: cellSize.width * CGFloat(cols),
                               height: cellSize.height * CGFloat(rows))
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(.secondary.opacity(0.3), lineWidth: 1)
                .background(RoundedRectangle(cornerRadius: 16).fill(.secondary.opacity(0.05)))
            Path { path in
                for r in 1..<rows {
                    let y = CGFloat(r) * cellSize.height - 0.5
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: totalSize.width, y: y))
                }
                for c in 1..<cols {
                    let x = CGFloat(c) * cellSize.width - 0.5
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: totalSize.height))
                }
            }
            .stroke(.secondary.opacity(0.25), style: StrokeStyle(lineWidth: 1, dash: [2, 3]))
        }
        .frame(width: totalSize.width, height: totalSize.height)
    }
}

final class WidgetDashboardEngine: ObservableObject {
    @Published var widgets: [WidgetItem]
    let rows: Int
    let cols: Int
    
    init(rows: Int = 4, cols: Int = 4, widgets: [WidgetItem]) {
        self.rows = rows
        self.cols = cols
        self.widgets = widgets
    }
    
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
