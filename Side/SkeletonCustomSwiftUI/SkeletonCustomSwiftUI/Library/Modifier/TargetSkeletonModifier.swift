import SwiftUI

struct TargetSkeletonModifier: ViewModifier {
    @EnvironmentObject var controller: SkeletonController
    @Environment(\.skeletonConfig) private var config
    
    var widthRatio: CGFloat
    var alignment: SkeletonAlignmentType
    var shape: SkeletonShapeType
    
    @State private var size: CGSize = .zero
    @State private var showSkeleton: Bool = false
    
    func body(content: Content) -> some View {
        ZStack {
            if !showSkeleton {
                content
            }
            
            if controller.isAnimating || showSkeleton {
                shape.clip(
                    controller.animationView(config)
                        .frame(
                            width: size.width * widthRatio,
                            height: size.height
                        )
                        .opacity(showSkeleton ? 1 : 0)
                        .animation(.easeInOut(duration: 0.3), value: showSkeleton)
                )
                .frame(
                    width: size.width,
                    height: size.height,
                    alignment: alignment.toAlignment
                )
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
        .onChange(of: controller.isAnimating) { _, newValue in
            if newValue {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showSkeleton = true
                }
            }
            else {
                Task {
                    try await Task.sleep(nanoseconds: 300_000_000)
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showSkeleton = false
                    }
                }
            }
        }
        .onAppear {
            if controller.isAnimating {
                Task {
                    try await Task.sleep(nanoseconds: 1)
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showSkeleton = true
                    }
                }
            }
        }
    }
    
}
