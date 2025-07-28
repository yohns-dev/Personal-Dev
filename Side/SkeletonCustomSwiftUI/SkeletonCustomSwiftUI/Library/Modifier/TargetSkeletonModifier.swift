import SwiftUI

struct TargetSkeletonModifier: ViewModifier {
    @EnvironmentObject var controller: SkeletonController
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Group {
                    if controller.isAnimating {
                        controller.animationView
                            .clipShape(RoundedRectangle(cornerRadius: 8)) 
                    } else {
                        EmptyView()
                    }
                }
            )
    }
}
