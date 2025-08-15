import SwiftUI
import SwiftData

struct WidgetDashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = WidgetDashboardViewModel()

    private enum Mode { case normal, edit, deleteSelect }
    @State private var mode: Mode = .normal
    @State private var deleteSelection = Set<UUID>()

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

// MARK: - Header
extension WidgetDashboardView {
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
                Menu {
                    Button {
                        withAnimation(.snappy(duration: 0.15)) {
                            mode = .edit
                        }
                    } label: {
                        Label("편집", systemImage: "slider.horizontal.3")
                    }
                    Menu {
                        Button {
                            viewModel.addWidget(kind: .calendar)
                        } label: {
                            Label("Calendar", systemImage: "calendar")
                        }
                        Button {
                            viewModel.addWidget(kind: .todo)
                        } label: {
                            Label("TODO", systemImage: "checklist")
                        }
                        Button {
                            viewModel.addWidget(kind: .memo)
                        } label: {
                            Label("Memo", systemImage: "note.text")
                        }
                    } label: {
                        Label("추가", systemImage: "plus.circle")
                    }
                    Button(role: .destructive) {
                        deleteSelection.removeAll()
                        withAnimation(.snappy(duration: 0.15)) {
                            mode = .deleteSelect
                        }
                    } label: {
                        Label("삭제", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.title3)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
                .menuOrder(.fixed)
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Grid Area
extension WidgetDashboardView {
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

                    ForEach(widgets, id: \WidgetItem.id) { widget in
                        if let rect = widget.rect {
                            let editing = (mode == .edit)
                            let deleteMode = (mode == .deleteSelect)
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
                            .allowsHitTesting(!deleteMode)
                            .overlay {
                                if deleteMode {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(selected ? .red : .clear, lineWidth: 3)
                                        .background(
                                            (selected ? Color.red.opacity(0.08) : .clear)
                                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                        )
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            if selected { deleteSelection.remove(widget.id) }
                                            else { deleteSelection.insert(widget.id) }
                                        }
                                }
                            }
                            .zIndex(deleteMode ? 10 : 0)
                        }
                    }
                }
            }
            .padding(12)
        }
    }
}

// MARK: - Grid Background (DEBUG aid)
extension WidgetDashboardView {
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
