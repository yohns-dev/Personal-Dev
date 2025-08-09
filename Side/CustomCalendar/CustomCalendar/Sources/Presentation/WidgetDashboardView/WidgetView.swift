import SwiftUI

struct WidgetView: View {
    @EnvironmentObject private var viewModel: WidgetDashboardViewModel
    
    let widget: WidgetItem
    let cellSize: CGSize
    let rows: Int
    let cols: Int
    
    // 드래그 컨트롤
    @State private var dragStartRect: WidgetGridRect?
    @State private var currentRect: WidgetGridRect
    @State private var isValid: Bool = true
    
    // 사이즈 컨트롤
    @State private var resizeStartRect: WidgetGridRect?
    @State private var liveResizeSize: CGSize?
    
    let isEditing: Bool
    
    init(widget: WidgetItem, cellSize: CGSize, rows: Int, cols: Int, isEditing: Bool) {
        self.widget = widget
        self.cellSize = cellSize
        self.rows = rows
        self.cols = cols
        self.isEditing = isEditing
        _currentRect = State(initialValue: widget.rect)
    }
    
    var body: some View {
        let displayFrame = getDisplayFrame()
        
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
        .gesture(dragGesture)
        .onChange(of: widget.rect) { _, newValue in
            currentRect = newValue
        }
        .animation(.snappy(duration: 0.12), value: currentRect)
    }
    
    private func getDisplayFrame() -> CGRect {
        let baseFrame = rectToFrame(currentRect, cellSize: cellSize)
        let displayWidth  = liveResizeSize?.width  ?? baseFrame.size.width
        let displayHeight = liveResizeSize?.height ?? baseFrame.size.height
        let displayFrame = CGRect(x: baseFrame.origin.x, y: baseFrame.origin.y, width: displayWidth, height: displayHeight)
        return displayFrame
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
                if isEditing {
                    if dragStartRect == nil { dragStartRect = currentRect }
                    guard let start = dragStartRect else { return }
                    
                    let dragCol = Int(round(value.translation.width / cellSize.width))
                    let dragRow = Int(round(value.translation.height / cellSize.height))
                    
                    var candidate = start
                    candidate.col = clamp(candidate.col + dragCol, 0, cols - candidate.colSpan)
                    candidate.row = clamp(candidate.row + dragRow, 0, rows - candidate.rowSpan)
                    
                    let (snap, result) = viewModel.tentativeValidRect(for: widget.id, candidate: candidate)
                    currentRect = snap
                    isValid = result
                }
            }
            .onEnded { _ in
                guard let start = dragStartRect else { return }
                dragStartRect = nil
                if isValid {
                    _ = viewModel.tryMove(widget.id, to: currentRect)
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
                    let startFrame = rectToFrame(currentRect, cellSize: cellSize)
                    liveResizeSize = startFrame.size
                }
                guard let start = resizeStartRect, var live = liveResizeSize else { return }
                
                live.width  += value.translation.width
                live.height += value.translation.height
                
                let minW = cellSize.width
                let minH = cellSize.height
                let maxW = CGFloat(cols - start.col) * cellSize.width
                let maxH = CGFloat(rows - start.row) * cellSize.height
                
                live.width  = max(minW, min(maxW, live.width))
                live.height = max(minH, min(maxH, live.height))
                
                liveResizeSize = live
                
                var newColSpan = Int(round(live.width  / cellSize.width))
                var newRowSpan = Int(round(live.height / cellSize.height))
                newColSpan = max(1, min(cols - start.col, newColSpan))
                newRowSpan = max(1, min(rows - start.row, newRowSpan))
                
                var candidate = start
                candidate.colSpan = newColSpan
                candidate.rowSpan = newRowSpan
                
                let (_, result) = viewModel.tentativeValidRect(for: widget.id, candidate: candidate)
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
                
                let (snap, result) = viewModel.tentativeValidRect(for: widget.id, candidate: candidate)
                if result {
                    currentRect = snap
                    _ = viewModel.tryMove(widget.id, to: snap)
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
