import SwiftUI

struct SkeletonCustomNode: View {
    let item: SkeletonItem
    let controller: SkeletonController
    let totalWidth: CGFloat

    var body: some View {
        switch item {
        case let .rectangle(widthRatio, height, cornerRadius):
            controller.animationView(nil)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .frame(width: totalWidth * widthRatio, height: height)

        case let .circle(size):
            controller.animationView(nil)
                .clipShape(Circle())
                .frame(width: size, height: size)

        case let .spacer(height):
            Spacer().frame(height: height)

        case let .vStack(spacing, alignment, items):
            VStack(alignment: alignment.toHorizontalAlignment ?? .center, spacing: spacing) {
                ForEach(0..<items.count, id: \.self) { index in
                    SkeletonCustomNode(item: items[index], controller: controller, totalWidth: totalWidth)
                }
            }

        case let .hStack(spacing, alignment, items):
            HStack(alignment: alignment.toVerticalAlignment ?? .center, spacing: spacing) {
                ForEach(0..<items.count, id: \.self) { index in
                    SkeletonCustomNode(item: items[index], controller: controller, totalWidth: totalWidth)
                }
            }
        }
    }
}

