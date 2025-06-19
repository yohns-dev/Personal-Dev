import SwiftUI

struct DraggableGridView: View {
    @State private var items: [String] = ["🍎", "🍌", "🍇", "🍓", "🍍", "🥝", "🍑", "🍊", "🍉"]
    @State private var draggingItem: String?
    @GestureState private var dragOffset: CGSize = .zero
    @State private var dragLocation: CGPoint = .zero
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 3)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(items, id: \.self) { item in
                GeometryReader { geo in
                    ItemView(
                        item: item,
                        isDragging: draggingItem == item,
                        dragOffset: draggingItem == item ? dragOffset : .zero
                    )
                    .onAppear {
                        DispatchQueue.main.async { }
                    }
                    .gesture(
                        LongPressGesture(minimumDuration: 0.2)
                            .sequenced(before: DragGesture())
                            .updating($dragOffset) { value, state, _ in
                                switch value {
                                case .second(true, let drag?):
                                    state = drag.translation
                                default:
                                    break
                                }
                            }
                            .onChanged { value in
                                switch value {
                                case .second(true, let drag?):
                                    self.dragLocation = geo.frame(in: .global).origin + drag.translation
                                    if draggingItem != item {
                                        draggingItem = item
                                    }
                                default:
                                    break
                                }
                            }
                            .onEnded { value in
                                guard let current = draggingItem,
                                      let from = items.firstIndex(of: current)
                                else { return }

                                if let target = getClosestIndex(to: dragLocation, excluding: from) {
                                    withAnimation {
                                        items.move(fromOffsets: IndexSet(integer: from), toOffset: target > from ? target + 1 : target)
                                    }
                                }

                                draggingItem = nil
                            }
                    )
                }
                .frame(height: 80)
            }
        }
        .frame(width: 250)
        .padding()
    }

    func getClosestIndex(to location: CGPoint, excluding: Int) -> Int? {
        var closest: (index: Int, distance: CGFloat)?
        for (i, _) in items.enumerated() where i != excluding {
            let frame = itemFrame(at: i)
            let center = CGPoint(x: frame.midX, y: frame.midY)
            let dist = hypot(center.x - location.x, center.y - location.y)
            if closest == nil || dist < closest!.distance {
                closest = (i, dist)
            }
        }
        return closest?.index
    }

    func itemFrame(at index: Int) -> CGRect {
        let colCount = columns.count
        let spacing: CGFloat = 16
        let itemSize: CGFloat = 80

        let col = index % colCount
        let row = index / colCount

        let x = CGFloat(col) * (itemSize + spacing)
        let y = CGFloat(row) * (itemSize + spacing)

        return CGRect(x: x, y: y, width: itemSize, height: itemSize)
    }
}

struct ItemView: View {
    let item: String
    let isDragging: Bool
    let dragOffset: CGSize

    var body: some View {
        Text(item)
            .font(.largeTitle)
            .frame(width: 80, height: 80)
            .background(isDragging ? Color.yellow.opacity(0.7) : Color.white)
            .cornerRadius(12)
            .shadow(radius: isDragging ? 6 : 2)
            .offset(dragOffset)
            .animation(.easeInOut(duration: 0.2), value: dragOffset)
    }
}

extension CGPoint {
    static func + (lhs: CGPoint, rhs: CGSize) -> CGPoint {
        CGPoint(x: lhs.x + rhs.width, y: lhs.y + rhs.height)
    }
}

#Preview {
    DraggableGridView()
}
