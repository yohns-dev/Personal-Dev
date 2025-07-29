import SwiftUI

struct SkeletonAnimationModifier: ViewModifier {
    @StateObject var controller: SkeletonController
    
//    var animation: SkeletonAnimationType
//    var baseColor: Color
//    var highlightColor: Color
    
    func body(content: Content) -> some View {
        content
            .environmentObject(controller)
            .onAppear { controller.startAnimating()}
//            .onAppear {
//                controller.animation = animation
//                controller.baseColor = baseColor
//                controller.highlightColor = highlightColor
//                controller.startAnimating()
//            }
    }
}

