import SwiftUI

class SkeletonController: ObservableObject {
    @Published var isAnimating: Bool = false
    
    var animation: SkeletonAnimationType
    var baseColor: Color
    var highlightColor: Color
    var defaultConfig: SkeletonAnimationConfig
    
    init(animation: SkeletonAnimationType,
         baseColor: Color = .gray,
         highlightColor: Color = .gray.opacity(0.6)) {
        self.animation = animation
        self.baseColor = baseColor
        self.highlightColor = highlightColor
        self.defaultConfig = animation.defaultConfig()
    }
    
    var animationView: (_ config: SkeletonAnimationConfig?) -> AnyView {
        { config in
            let resolved = config ?? self.defaultConfig
            switch self.animation {
            case .pulse:
                return AnyView(PulseAnimation(baseColor: self.baseColor, config: resolved))
            case .shimmer:
                return AnyView(ShimmerAnimation(baseColor: self.baseColor, highlightColor: self.highlightColor, config: resolved))
            }
        }
    }
    
    func startAnimating() {
        isAnimating = true
    }
    
    func stopAnimating() {
        isAnimating = false
    }
}
