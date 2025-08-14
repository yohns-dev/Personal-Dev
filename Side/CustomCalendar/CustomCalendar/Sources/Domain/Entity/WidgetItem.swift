import Foundation
import SwiftData

enum WidgetKind: String, Codable, CaseIterable {
    case calendar, todo, memo
}

struct WidgetGridRect: Equatable, Hashable {
    var row: Int
    var col: Int
    var rowSpan: Int
    var colSpan: Int
}

@Model
final class WidgetItem {
    @Attribute(.unique) var id: UUID
    var kind: WidgetKind
    var title: String
    var row: Int?
    var col: Int?
    var rowSpan: Int?
    var colSpan: Int?
    var createdAt: Date
    
    
    init(id: UUID = UUID(), kind: WidgetKind, title: String, rect: WidgetGridRect? = nil, createdAt: Date = .now) {
        self.id = id
        self.kind = kind
        self.title = title
        self.createdAt = createdAt
        
        self.row = rect?.row ?? nil
        self.col = rect?.col ?? nil
        self.rowSpan = rect?.rowSpan ?? nil
        self.colSpan = rect?.colSpan ?? nil
    }
    
    var rect: WidgetGridRect? {
        get {
            if let row, let col, let rowSpan, let colSpan {
                return .init(row: row, col: col, rowSpan: rowSpan, colSpan: colSpan)
            }
            return nil
        }
        set {
            row = newValue?.row ?? nil
            col = newValue?.col ?? nil
            rowSpan = newValue?.rowSpan ?? nil
            colSpan = newValue?.colSpan ?? nil
        }
    }
}
