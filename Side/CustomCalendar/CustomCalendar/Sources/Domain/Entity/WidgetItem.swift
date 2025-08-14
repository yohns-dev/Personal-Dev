import Foundation
import SwiftData

enum WidgetKind: String, Codable, CaseIterable {
    case calendar, todo, memo
}

@Model
final class WidgetItem {
    @Attribute(.unique) var id: UUID
    var kind: WidgetKind
    var title: String
    var row: Int
    var col: Int
    var rowSpan: Int
    var colSpan: Int
    
    
    init(id: UUID = UUID(), kind: WidgetKind, title: String, rect: WidgetGridRect) {
        self.id = id
        self.kind = kind
        self.title = title
        self.row = rect.row
        self.col = rect.col
        self.rowSpan = rect.rowSpan
        self.colSpan = rect.colSpan
    }
    
    var rect: WidgetGridRect {
        get {.init(row: row, col: col, rowSpan: rowSpan, colSpan: colSpan)}
        set {
            row = newValue.row
            col = newValue.col
            rowSpan = newValue.rowSpan
            colSpan = newValue.colSpan
        }
    }
}

struct WidgetGridRect: Equatable, Hashable {
    var row: Int
    var col: Int
    var rowSpan: Int
    var colSpan: Int
}
