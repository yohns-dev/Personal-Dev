import SwiftUI

struct TargetSkeletonModifier: ViewModifier {
    @EnvironmentObject var controller: SkeletonController
    var widthRatio: CGFloat
    var alignment: SkeletonAlignmentType
    var shape: SkeletonShapeType
    
    @State private var size: CGSize = .zero
    
    func body(content: Content) -> some View {
        ZStack {
            if controller.isAnimating && size != .zero {
                shape.clip(
                    controller.animationView
                        .frame(
                            width: size.width * widthRatio,
                            height: size.height,
                            alignment: .leading
                        )
                )
                .frame(
                    width: size.width,
                    height: size.height,
                    alignment: alignment.toAlignment
                )
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
        .frame(
            width: size == .zero ? nil : size.width,
            height: size == .zero ? nil : size.height
        )
    }
    
}
