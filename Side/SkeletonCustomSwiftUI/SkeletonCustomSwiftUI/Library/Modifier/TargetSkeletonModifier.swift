import SwiftUI

struct TargetSkeletonModifier: ViewModifier {
    @EnvironmentObject var controller: SkeletonController
    var widthRatio: CGFloat

    @State private var size: CGSize = .zero

    func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            if controller.isAnimating {
                controller.animationView
                    .frame(
                        width: size.width * widthRatio,
                        height: size.height
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                content
            }
        }
        .background(
            content
                .hidden()
                .readSize { newSize in
                    self.size = newSize
                }
        )
    }
}
