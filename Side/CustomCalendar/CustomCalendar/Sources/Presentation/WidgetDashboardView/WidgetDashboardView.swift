import SwiftUI


struct WidgetDashboardView: View {
    //TODO: widget을 viewModel 자체에서 생성하게 만들고 SwiftData를 통해 widget 관리할 수 있도록 만들기
    @StateObject private var viewModel = WidgetDashboardViewModel(
        widgets: [
            WidgetItem(id: UUID(), title: "Calendar", rect: .init(row: 0, col: 0, rowSpan: 2, colSpan: 2)),
            WidgetItem(id: UUID(), title: "TODO", rect: .init(row: 0, col: 2, rowSpan: 1, colSpan: 2)),
            WidgetItem(id: UUID(), title: "Memo", rect: .init(row: 2, col: 0, rowSpan: 2, colSpan: 3))
        ]
    )
    
    var body: some View {
        GeometryReader { geometry in
            //TODO: 최종적으로 CGSize는 정사각형으로 될 수있도록 계산 식 추가 필요
            let cellSize = CGSize(width: geometry.size.width / CGFloat(viewModel.cols), height: geometry.size.height / CGFloat(viewModel.rows))
            
            ZStack {
                #if DEBUG // 실선 표시
                gridBackground(rows: viewModel.rows, cols: viewModel.cols, cellSize: cellSize)
                #endif
                ForEach(viewModel.widgets) { widget in
                    WidgetView(widget: widget, cellSize: cellSize, rows: viewModel.rows, cols: viewModel.cols)
                }
            }
            .padding(12)
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

