import SwiftUI

struct SkeletonAnimationModifier: ViewModifier {
    @StateObject var controller: SkeletonController
    
    func body(content: Content) -> some View {
        content
            .environmentObject(controller)
            .onAppear { controller.startAnimating() }
    }
}

