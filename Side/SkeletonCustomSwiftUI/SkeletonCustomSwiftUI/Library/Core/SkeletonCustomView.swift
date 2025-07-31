import SwiftUI

struct SkeletonCustomView: View {
    let controller: SkeletonController
    let items: [SkeletonItem]
    let rootStack: SkeletonStackType
    var baseColor: Color
    var highlightColor: Color
    
    var body: some View {
        GeometryReader { geometry in
            let totalWidth = geometry.size.width
            buildStack(from: items, totalWidth: totalWidth)
                .allowsHitTesting(false)
        }
    }
    
    private func buildStack(from items: [SkeletonItem], totalWidth: CGFloat) -> some View {
        switch rootStack {
        case let .vStack(spacing, alignment):
            return AnyView(
                VStack(alignment: alignment.toHorizontalAlignment ?? .center, spacing: spacing) {
                    renderItems(items, totalWidth: totalWidth)
                }
            )
            
        case let .hStack(spacing, alignment):
            return AnyView(
                HStack(alignment: alignment.toVerticalAlignment ?? .center, spacing: spacing) {
                    renderItems(items, totalWidth: totalWidth)
                }
            )
        }
    }
    
    private func renderItems(_ items: [SkeletonItem], totalWidth: CGFloat) -> some View {
        ForEach(0..<items.count, id: \.self) { idx in
            renderItem(items[idx], totalWidth: totalWidth)
        }
    }

    private func renderItem(_ item: SkeletonItem, totalWidth: CGFloat) -> some View {
        switch item {
        case let .rectangle(widthRatio, height, cornerRadius):
            return AnyView(
                controller.animationView(nil)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                    .frame(width: totalWidth * widthRatio, height: height)
            )
            
        case let .circle(size):
            return AnyView(
                controller.animationView(nil)
                    .clipShape(Circle())
                    .frame(width: size, height: size)
            )
            
        case let .spacer(height):
            return AnyView(Spacer().frame(height: height))
            
        case let .hStack(spacing, alignment, items):
            return AnyView(
                HStack(alignment: alignment.toVerticalAlignment ?? .center, spacing: spacing) {
                    renderItems(items, totalWidth: totalWidth)
                }
            )
            
        case let .vStack(spacing, alignment, items):
            return AnyView(
                VStack(alignment: alignment.toHorizontalAlignment ?? .center, spacing: spacing) {
                    renderItems(items, totalWidth: totalWidth)
                }
            )
        }
    }
}
