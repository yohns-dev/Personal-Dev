import SwiftUI

class SkeletonController: ObservableObject {
    @Published var isAnimating: Bool = false
    
    var animation: SkeletonAnimationType
    var baseColor: Color
    var highlightColor: Color
    var defaultConfig: SkeletonAnimationConfig
    
    init(animation: SkeletonAnimationType,
         baseColor: Color = Color(hue: 0, saturation: 0, brightness: 0.75),
         highlightColor: Color = Color(hue: 0, saturation: 0, brightness: 0.92)){
        self.animation = animation
        self.baseColor = baseColor
        self.highlightColor = highlightColor
        self.defaultConfig = animation.defaultConfig()
    }
    
    @ViewBuilder
    func animationView(_ config: SkeletonAnimationConfig?) -> some View {
        let selectedConfig = config ?? defaultConfig
        animation.makeView(baseColor: baseColor, highlightColor: highlightColor, config: selectedConfig)
    }
    
    func startAnimating() {
        isAnimating = true
    }
    
    func stopAnimating() {
        isAnimating = false
    }
}

