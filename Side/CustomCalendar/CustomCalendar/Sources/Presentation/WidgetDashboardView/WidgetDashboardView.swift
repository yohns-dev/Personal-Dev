import SwiftUI
import SwiftData

struct WidgetDashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = WidgetDashboardViewModel()
    
    private enum Mode { case normal, edit, deleteSelect }
    @State private var mode: Mode = .normal
    @State private var deleteSelection = Set<UUID>()
    
    @State private var headerAnchor: NSView?
    @StateObject private var headerPopover = WidgetDashboardSettingPopupView()
    
    var body: some View {
        VStack(spacing: 12) {
            header()
                .zIndex(1000)
            gridArea()
                .zIndex(0)
        }
        .task {
            viewModel.attachModelContext(modelContext)
            viewModel.loadWidgets()
        }
        .environmentObject(viewModel)
    }
}

extension WidgetDashboardView {
    // MARK: - Header
    @ViewBuilder
    private func header() -> some View {
        HStack {
            Text("Dashboard")
                .font(.title2).bold()
            
            Spacer()
            
            if mode == .deleteSelect {
                Button("취소") {
                    deleteSelection.removeAll()
                    mode = .normal
                }
                .padding(.trailing, 6)
                
                Button("삭제하기", role: .destructive) {
                    viewModel.removeWidgets(ids: Array(deleteSelection))
                    deleteSelection.removeAll()
                    mode = .normal
                }
                .disabled(deleteSelection.isEmpty)
            }
            
            if mode == .edit {
                Button {
                    withAnimation(.snappy(duration: 0.15)) {
                        mode = .normal
                        viewModel.activeWidgetID = nil
                    }
                } label: {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            } else {
                Button {
                    if let v = headerAnchor {
                        headerPopover.show(relativeTo: v) {
                            headerPopoverContent()
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.title3)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .overlay(
                    WidgetDashboardSettingPopupAnchorView(nsView: $headerAnchor)
                        .allowsHitTesting(false)
                )
            }
        }
        .padding(.vertical, 8)
    }
    
    @ViewBuilder
    private func headerPopoverContent() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Button {
                withAnimation(.snappy(duration: 0.15)) {
                    mode = .edit
                }
                headerPopover.close()
            } label: {
                Label("편집", systemImage: "slider.horizontal.3")
            }
            .buttonStyle(.plain)
            
            Divider()
            
            Text("추가")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 8) {
                Button {
                    viewModel.addWidget(kind: .calendar)
                    headerPopover.close()
                } label: { Label("Calendar", systemImage: "calendar") }
                    .buttonStyle(.plain)
                
                Button {
                    viewModel.addWidget(kind: .todo)
                    headerPopover.close()
                } label: { Label("TODO", systemImage: "checklist") }
                    .buttonStyle(.plain)
                
                Button {
                    viewModel.addWidget(kind: .memo)
                    headerPopover.close()
                } label: { Label("Memo", systemImage: "note.text") }
                    .buttonStyle(.plain)
            }
            
            Divider()
            
            Button(role: .destructive) {
                deleteSelection.removeAll()
                withAnimation(.snappy(duration: 0.15)) {
                    mode = .deleteSelect
                }
                headerPopover.close()
            } label: {
                Label("삭제", systemImage: "trash")
            }
            .buttonStyle(.plain)
        }
        .padding(12)
        .frame(width: 260)
    }
}

extension WidgetDashboardView {
    // MARK: - Grid Area
    @ViewBuilder
    private func gridArea() -> some View {
        GeometryReader { geometry in
            let cellSize = CGSize(
                width: geometry.size.width / CGFloat(viewModel.cols),
                height: geometry.size.height / CGFloat(viewModel.rows)
            )
            
            ZStack {
#if DEBUG
                gridBackground(rows: viewModel.rows, cols: viewModel.cols, cellSize: cellSize)
#endif
                if viewModel.widgets.first(where: { $0.rect != nil }) == nil {
                    ContentUnavailableView(
                        "위젯이 없습니다",
                        systemImage: "square.grid.3x3",
                        description: Text("오른쪽 상단 … 버튼을 탭해 추가하세요.")
                    )
                } else {
                    let widgets: [WidgetItem] = viewModel.widgets
                    let deleteMode = (mode == .deleteSelect)
                    
                    ForEach(widgets, id: \WidgetItem.id) { widget in
                        if let rect = widget.rect {
                            let editing = (mode == .edit)
                            let selected = deleteSelection.contains(widget.id)
                            
                            WidgetView(
                                widget: widget,
                                initialRect: rect,
                                cellSize: cellSize,
                                rows: viewModel.rows,
                                cols: viewModel.cols,
                                isEditing: editing,
                                tentative: { id, cand in
                                    viewModel.tentativeValidRect(for: id, candidate: cand)
                                },
                                commitMove: { id, newRect in
                                    viewModel.commitMove(id: id, to: newRect)
                                }
                            ) { _ in
                                switch widget.kind {
                                case .calendar: CalendarWidgetView()
                                case .todo:     TodoWidgetView()
                                case .memo:     MemoWidgetView()
                                }
                            }
                            .onTapGesture {
                                guard deleteMode else { return }
                                if !selected {
                                    deleteSelection.insert(widget.id)
                                }
                            }
                        }
                    }
                    
                    if deleteMode {
                        ForEach(widgets.filter { deleteSelection.contains($0.id) }, id: \.id) { widget in
                            if let rect = widget.rect {
                                let frame = pixelFrame(from: rect, cellSize: cellSize)
                                
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.red, lineWidth: 3)
                                    .background(
                                        Color.red.opacity(0.08)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                    )
                                    .frame(width: frame.width, height: frame.height)
                                    .position(x: frame.midX, y: frame.midY)
                                    .onTapGesture {
                                        deleteSelection.remove(widget.id)
                                    }
                            }
                        }
                        ForEach(widgets.filter { $0.rect != nil && !deleteSelection.contains($0.id) }, id: \.id) { widget in
                            let frame = pixelFrame(from: widget.rect!, cellSize: cellSize)
                            
                            Color.clear
                                .frame(width: frame.width, height: frame.height)
                                .position(x: frame.midX, y: frame.midY)
                        }
                    }
                }
            }
            .padding(12)
            .animation(.snappy(duration: 0.12), value: deleteSelection)
            .animation(.snappy(duration: 0.12), value: mode)
        }
    }
    
    private func pixelFrame(from rect: WidgetGridRect, cellSize: CGSize) -> CGRect {
        CGRect(
            x: CGFloat(rect.col) * cellSize.width,
            y: CGFloat(rect.row) * cellSize.height,
            width: CGFloat(rect.colSpan) * cellSize.width,
            height: CGFloat(rect.rowSpan) * cellSize.height
        )
    }
}

extension WidgetDashboardView {
    // MARK: - Grid Background (DEBUG aid)
    @ViewBuilder
    fileprivate func gridBackground(rows: Int, cols: Int, cellSize: CGSize) -> some View {
        let totalSize = CGSize(width: cellSize.width * CGFloat(cols),
                               height: cellSize.height * CGFloat(rows))
        
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(.secondary.opacity(0.3), lineWidth: 1)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.secondary.opacity(0.05))
                )
            
            Path { path in
                for row in 1..<rows {
                    let y = CGFloat(row) * cellSize.height - 0.5
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: totalSize.width, y: y))
                }
                for col in 1..<cols {
                    let x = CGFloat(col) * cellSize.width - 0.5
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: totalSize.height))
                }
            }
            .stroke(.secondary.opacity(0.25),
                    style: StrokeStyle(lineWidth: 1, dash: [2, 3]))
        }
        .frame(width: totalSize.width, height: totalSize.height)
    }
}


