import SwiftUI
import SwiftData


struct WidgetDashboardView: View {
    //TODO: widget을 viewModel 자체에서 생성하게 만들고 SwiftData를 통해 widget 관리할 수 있도록 만들기
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = WidgetDashboardViewModel()
    @Binding var isEditing: Bool
    
    var body: some View {
        GeometryReader { geometry in
            //TODO: 최종적으로 CGSize는 정사각형으로 될 수있도록 계산 식 추가 필요
            let cellSize = CGSize(width: geometry.size.width / CGFloat(viewModel.cols), height: geometry.size.height / CGFloat(viewModel.rows))
            
            ZStack {
#if DEBUG // 실선 표시
                gridBackground(rows: viewModel.rows, cols: viewModel.cols, cellSize: cellSize)
#endif
                if viewModel.widgets.first(where: {$0.rect != nil}) == nil {
                    ContentUnavailableView("위젯이 없습니다", systemImage: "square.grid.3x3", description: Text("우측 상단의 + 버튼으로 위젯을 추가하세요."))
                } else {
                    ForEach(viewModel.widgets, id: \.id) { widget in
                        if let rect = widget.rect {
                            WidgetView(
                                widget: widget,
                                initialRect: rect,
                                cellSize: cellSize,
                                rows: viewModel.rows,
                                cols: viewModel.cols,
                                isEditing: isEditing,
                                tentative: { id, candidate in
                                    viewModel.tentativeValidRect(for: id, candidate: candidate)
                                },
                                commitMove: { id, rect in
                                    viewModel.commitMove(id: id, to: rect)
                                }
                            ) { _ in
                                switch widget.kind {
                                case .calendar: CalendarWidgetView()
                                case .todo:     TodoWidgetView()
                                case .memo:     MemoWidgetView()
                                }
                            }
                        }
                    }
                }
            }
            .padding(12)
        }
        .task {
            viewModel.attachModelContext(modelContext)
            viewModel.loadWidgets()
        }
        .environmentObject(viewModel)
    }
}

//MARK: View Builder 실선
extension WidgetDashboardView {
    @ViewBuilder
    private func gridBackground(rows: Int, cols: Int, cellSize: CGSize) -> some View {
        let totalSize = CGSize(width: cellSize.width * CGFloat(cols), height: cellSize.height * CGFloat(rows))
        
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(.secondary.opacity(0.3), lineWidth: 1)
                .background(RoundedRectangle(cornerRadius: 16).fill(.secondary.opacity(0.05)))
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
            .stroke(.secondary.opacity(0.25), style: StrokeStyle(lineWidth: 1, dash: [2, 3]))
            
        }
        .frame(width: totalSize.width, height: totalSize.height)
    }
}

