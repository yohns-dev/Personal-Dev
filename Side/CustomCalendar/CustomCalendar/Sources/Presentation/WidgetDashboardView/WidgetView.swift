import SwiftUI

struct WidgetView: View {
    let widget: WidgetItem
    let cellSize: CGSize
    let rows: Int
    let cols: Int

    let onRectPreview: (WidgetGridRect) -> (WidgetGridRect, Bool)
    let onCommit: (WidgetGridRect) -> Void

    @State private var dragStartRect: WidgetGridRect?
    @State private var currentRect: WidgetGridRect
    @State private var isValid: Bool = true

    @State private var resizeStartRect: WidgetGridRect?
    @State private var liveResizeSize: CGSize?

    init(widget: WidgetItem,
         cellSize: CGSize,
         rows: Int,
         cols: Int,
         onRectPreview: @escaping (WidgetGridRect) -> (WidgetGridRect, Bool),
         onCommit: @escaping (WidgetGridRect) -> Void)
    {
        self.widget = widget
        self.cellSize = cellSize
        self.rows = rows
        self.cols = cols
        self.onRectPreview = onRectPreview
        self.onCommit = onCommit
        _currentRect = State(initialValue: widget.rect)
    }

    var body: some View {
        let baseFrame = rectToFrame(currentRect, cellSize: cellSize)
        let displayWidth  = liveResizeSize?.width  ?? baseFrame.size.width
        let displayHeight = liveResizeSize?.height ?? baseFrame.size.height
        let displayFrame = CGRect(
            x: baseFrame.origin.x,
            y: baseFrame.origin.y,
            width: displayWidth,
            height: displayHeight
        )

        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 12)
                .fill(.orange)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isValid ? Color.clear : Color.red, lineWidth: 3)
                )
            Text(widget.title)
                .font(.headline)
                .foregroundStyle(.white)
                .padding(8)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    ResizeHandle()
                        .gesture(resizeGesture)
                        .padding(6)
                }
            }
        }
        .frame(width: displayFrame.size.width, height: displayFrame.size.height)
        .position(x: displayFrame.midX, y: displayFrame.midY)
        .gesture(dragGesture)
        .onChange(of: widget.rect) { _, newValue in
            currentRect = newValue
        }
        .animation(.snappy(duration: 0.12), value: currentRect)
    }

    private func rectToFrame(_ rect: WidgetGridRect, cellSize: CGSize) -> CGRect {
        CGRect(x: CGFloat(rect.col) * cellSize.width,
               y: CGFloat(rect.row) * cellSize.height,
               width: CGFloat(rect.colSpan) * cellSize.width,
               height: CGFloat(rect.rowSpan) * cellSize.height)
    }

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 4)
            .onChanged { value in
                if dragStartRect == nil { dragStartRect = currentRect }
                guard let start = dragStartRect else { return }

                let dCol = Int(round(value.translation.width / cellSize.width))
                let dRow = Int(round(value.translation.height / cellSize.height))

                var candidate = start
                candidate.col = clamp(candidate.col + dCol, 0, cols - candidate.colSpan)
                candidate.row = clamp(candidate.row + dRow, 0, rows - candidate.rowSpan)

                let (snap, ok) = onRectPreview(candidate)
                currentRect = snap
                isValid = ok
            }
            .onEnded { _ in
                guard let start = dragStartRect else { return }
                dragStartRect = nil
                if isValid { onCommit(currentRect) } else { currentRect = start }
                isValid = true
            }
    }

    private var resizeGesture: some Gesture {
        DragGesture(minimumDistance: 4)
            .onChanged { value in
                if resizeStartRect == nil {
                    resizeStartRect = currentRect
                    let startFrame = rectToFrame(currentRect, cellSize: cellSize)
                    liveResizeSize = startFrame.size
                }
                guard
                    let start = resizeStartRect,
                    var live = liveResizeSize
                else { return }

                live.width  += value.translation.width
                live.height += value.translation.height

                let minW = cellSize.width
                let minH = cellSize.height
                let maxW = CGFloat(cols - start.col) * cellSize.width
                let maxH = CGFloat(rows - start.row) * cellSize.height

                live.width  = max(minW, min(maxW, live.width))
                live.height = max(minH, min(maxH, live.height))

                liveResizeSize = live
                isValid = true
            }
            .onEnded { _ in
                guard
                    let start = resizeStartRect,
                    let live = liveResizeSize
                else { return }

                var newColSpan = Int(round(live.width  / cellSize.width))
                var newRowSpan = Int(round(live.height / cellSize.height))

                newColSpan = max(1, min(cols - start.col, newColSpan))
                newRowSpan = max(1, min(rows - start.row, newRowSpan))

                var candidate = start
                candidate.colSpan = newColSpan
                candidate.rowSpan = newRowSpan

                let (snap, ok) = onRectPreview(candidate)
                if ok {
                    currentRect = snap
                    onCommit(snap)
                } else {
                    currentRect = start
                }

                resizeStartRect = nil
                liveResizeSize = nil
                isValid = true
            }
    }

    private func clamp(_ v: Int, _ lo: Int, _ hi: Int) -> Int { min(max(v, lo), hi) }
}


// MARK: - Small UI bits
struct ResizeHandle: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(.ultraThinMaterial)
                .frame(width: 28, height: 20)
                .overlay(
                    VStack(spacing: 2) {
                        Rectangle().frame(height: 2).opacity(0.8)
                        Rectangle().frame(height: 2).opacity(0.6)
                        Rectangle().frame(height: 2).opacity(0.4)
                    }
                    .padding(.horizontal, 6)
                    .foregroundStyle(.primary)
                )
                .shadow(radius: 2, y: 1)
        }
        .accessibilityLabel("Resize")
    }
}
