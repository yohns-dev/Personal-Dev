import Foundation

struct WidgetItem: Identifiable, Equatable, Hashable {
    let id: UUID
    var title: String
    var rect: WidgetGridRect
}

struct WidgetGridRect: Equatable, Hashable {
    var row: Int
    var col: Int
    var rowSpan: Int
    var colSpan: Int
}

