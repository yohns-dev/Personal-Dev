import SwiftUI

struct TargetSkeletonModifier: ViewModifier {
    @EnvironmentObject var controller: SkeletonController
    @Environment(\.skeletonConfig) private var config
    
    var widthRatio: CGFloat
    var heightRatio: CGFloat
    var alignment: SkeletonAlignmentType
    var shape: SkeletonShapeType
    
    @State private var size: CGSize?
    @State private var showSkeleton: Bool = false

    func body(content: Content) -> some View {
        ZStack {
            if !showSkeleton {
                content
            }

            if let size, controller.isAnimating || showSkeleton {
                shape.clip(
                    controller.animationView(config)
                        .frame(
                            width: size.width * widthRatio,
                            height: size.height * heightRatio
                        )
                        .opacity(showSkeleton ? 1 : 0)
                        .animation(.easeInOut(duration: 0.3), value: showSkeleton)
                )
                .frame(width: size.width, height: size.height, alignment: alignment.toAlignment)
            }
        }
        .background(
            content
                .hidden()
                .readSize { newSize in
                    self.size = newSize
                }
        )
        .onChange(of: controller.isAnimating) { _, newValue in
            withAnimation(.easeInOut(duration: 0.3)) {
                showSkeleton = newValue
            }
        }
        .onAppear {
            if controller.isAnimating {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showSkeleton = true
                }
            }
        }
    }
}
