import SwiftUI

struct SkeletonCustomView: View {
    let controller: SkeletonController
    let items: [SkeletonItem]
    let rootStack: SkeletonStackType
    var baseColor: Color
    var highlightColor: Color

    @State private var totalWidth: CGFloat?

    var body: some View {
        ZStack(alignment: .topLeading) {
            if let width = totalWidth {
                stackRootView(totalWidth: width)
                    .fixedSize(horizontal: false, vertical: true)
                    .allowsHitTesting(false)
            }

            GeometryReader { geometry in
                Color.clear
                    .onAppear {
                        totalWidth = geometry.size.width
                    }
            }
            .frame(height: 0)
        }
    }

    @ViewBuilder
    private func stackRootView(totalWidth: CGFloat) -> some View {
        switch rootStack {
        case let .vStack(spacing, alignment):
            VStack(alignment: alignment.toHorizontalAlignment ?? .center, spacing: spacing) {
                ForEach(0..<items.count, id: \.self) { index in
                    SkeletonCustomNode(item: items[index], controller: controller, totalWidth: totalWidth)
                }
            }

        case let .hStack(spacing, alignment):
            HStack(alignment: alignment.toVerticalAlignment ?? .center, spacing: spacing) {
                ForEach(0..<items.count, id: \.self) { index in
                    SkeletonCustomNode(item: items[index], controller: controller, totalWidth: totalWidth)
                }
            }
        }
    }
}
