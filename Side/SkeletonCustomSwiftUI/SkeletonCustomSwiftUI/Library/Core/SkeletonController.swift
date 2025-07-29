import SwiftUI

class SkeletonController: ObservableObject {
    @Published var isAnimating: Bool = false
    
    var animation: SkeletonAnimationType
    var baseColor: Color
    var highlightColor: Color
    
    init(animation: SkeletonAnimationType,
         baseColor: Color = .gray,
         highlightColor: Color = .gray.opacity(0.6)) {
        self.animation = animation
        self.baseColor = baseColor
        self.highlightColor = highlightColor
    }
    
    var animationView: some View {
        switch animation {
        case .pulse: return AnyView(PulseAnimation(baseColor: baseColor))
        case .shimmer: return AnyView(ShimmerAnimation(baseColor: baseColor, highlightColor: highlightColor))
        }
    }
    
    func startAnimating() {
        isAnimating = true
    }
    
    func stopAnimating() {
        isAnimating = false
    }
}
