import SwiftUI

struct WidgetView<Content: View>: View {
    let widget: WidgetItem
    let cellSize: CGSize
    let rows: Int
    let cols: Int
    let isEditing: Bool
    
    // 검증/커밋 콜백
    let tentative: (_ id: UUID, _ candidate: WidgetGridRect) -> (WidgetGridRect, Bool)
    let commitMove: (_ id: UUID, _ rect: WidgetGridRect) -> Bool
    
    @ViewBuilder let content: (_ availableSize: CGSize) -> Content
    
    // 드래그 컨트롤
    @State private var dragStartRect: WidgetGridRect?
    @State private var currentRect: WidgetGridRect
    @State private var isValid: Bool = true
    
    // 리사이즈 컨트롤
    @State private var resizeStartRect: WidgetGridRect?
    @State private var liveResizeSize: CGSize?
    
    init(
        widget: WidgetItem,
        cellSize: CGSize,
        rows: Int,
        cols: Int,
        isEditing: Bool,
        tentative: @escaping (_ id: UUID, _ candidate: WidgetGridRect) -> (WidgetGridRect, Bool),
        commitMove: @escaping (_ id: UUID, _ rect: WidgetGridRect) -> Bool,
        @ViewBuilder content: @escaping (_ availableSize: CGSize) -> Content
    ) {
        self.widget = widget
        self.cellSize = cellSize
        self.rows = rows
        self.cols = cols
        self.isEditing = isEditing
        self.tentative = tentative
        self.commitMove = commitMove
        self.content = content
        _currentRect = State(initialValue: widget.rect)
    }
    
    var body: some View {
        let displayFrame = getDisplayFrame()
        let innerSize = displayFrame.size
        
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 12)
                .fill(.orange)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isValid ? Color.clear : Color.red, lineWidth: 3)
                )
            
            VStack(alignment: .leading, spacing: 8) {
                ZStack {
                    content(innerSize)
                        .allowsHitTesting(!isEditing)
                }
                .padding(8)
                .clipped()
            }
            
            if isEditing {
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
        }
        .frame(width: displayFrame.size.width, height: displayFrame.size.height)
        .position(x: displayFrame.midX, y: displayFrame.midY)
        .gesture(isEditing ? dragGesture : nil)
        // SwiftData값을 추적하여 자동으로 변경되게 함.
        .onChange(of: widget.row)      { _, _ in currentRect = widget.rect }
        .onChange(of: widget.col)      { _, _ in currentRect = widget.rect }
        .onChange(of: widget.rowSpan)  { _, _ in currentRect = widget.rect }
        .onChange(of: widget.colSpan)  { _, _ in currentRect = widget.rect }
        .animation(.snappy(duration: 0.12), value: currentRect)
    }
    
    private func getDisplayFrame() -> CGRect {
        let baseFrame = rectToFrame(currentRect, cellSize: cellSize)
        let displayWidth  = liveResizeSize?.width  ?? baseFrame.size.width
        let displayHeight = liveResizeSize?.height ?? baseFrame.size.height
        return CGRect(x: baseFrame.origin.x, y: baseFrame.origin.y, width: displayWidth, height: displayHeight)
    }
    
    private func rectToFrame(_ rect: WidgetGridRect, cellSize: CGSize) -> CGRect {
        CGRect(
            x: CGFloat(rect.col) * cellSize.width,
            y: CGFloat(rect.row) * cellSize.height,
            width: CGFloat(rect.colSpan) * cellSize.width,
            height: CGFloat(rect.rowSpan) * cellSize.height
        )
    }
    
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 4)
            .onChanged { value in
                if dragStartRect == nil { dragStartRect = currentRect }
                guard let start = dragStartRect else { return }
                
                let dragCol = Int(round(value.translation.width  / cellSize.width))
                let dragRow = Int(round(value.translation.height / cellSize.height))
                
                var candidate = start
                candidate.col = clamp(candidate.col + dragCol, 0, cols - candidate.colSpan)
                candidate.row = clamp(candidate.row + dragRow, 0, rows - candidate.rowSpan)
                
                let (snap, result) = tentative(widget.id, candidate)
                currentRect = snap
                isValid = result
            }
            .onEnded { _ in
                guard let start = dragStartRect else { return }
                dragStartRect = nil
                if isValid {
                    if !commitMove(widget.id, currentRect) { currentRect = start }
                } else {
                    currentRect = start
                }
                isValid = true
            }
    }
    
    private var resizeGesture: some Gesture {
        DragGesture(minimumDistance: 4)
            .onChanged { value in
                if resizeStartRect == nil {
                    resizeStartRect = currentRect
                    liveResizeSize = rectToFrame(currentRect, cellSize: cellSize).size
                }
                guard let start = resizeStartRect, var live = liveResizeSize else { return }
                
                live.width  += value.translation.width
                live.height += value.translation.height
                
                let minWidth = cellSize.width
                let minHeight = cellSize.height
                let maxWidth = CGFloat(cols - start.col) * cellSize.width
                let maxHeight = CGFloat(rows - start.row) * cellSize.height
                
                live.width  = max(minWidth, min(maxWidth, live.width))
                live.height = max(minHeight, min(maxHeight, live.height))
                
                liveResizeSize = live
                
                var newColSpan = Int(round(live.width  / cellSize.width))
                var newRowSpan = Int(round(live.height / cellSize.height))
                newColSpan = max(1, min(cols - start.col, newColSpan))
                newRowSpan = max(1, min(rows - start.row, newRowSpan))
                
                var candidate = start
                candidate.colSpan = newColSpan
                candidate.rowSpan = newRowSpan
                
                let (_, result) = tentative(widget.id, candidate)
                isValid = result
            }
            .onEnded { _ in
                guard let start = resizeStartRect, let live = liveResizeSize else { return }
                
                var newColSpan = Int(round(live.width  / cellSize.width))
                var newRowSpan = Int(round(live.height / cellSize.height))
                newColSpan = max(1, min(cols - start.col, newColSpan))
                newRowSpan = max(1, min(rows - start.row, newRowSpan))
                
                var candidate = start
                candidate.colSpan = newColSpan
                candidate.rowSpan = newRowSpan
                
                let (snap, result) = tentative(widget.id, candidate)
                if result {
                    if !commitMove(widget.id, snap) { currentRect = start }
                    else { currentRect = snap }
                } else {
                    currentRect = start
                }
                
                resizeStartRect = nil
                liveResizeSize = nil
                isValid = true
            }
    }
    
    private func clamp(_ value: Int, _ low: Int, _ high: Int) -> Int { min(max(value, low), high) }
}

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
