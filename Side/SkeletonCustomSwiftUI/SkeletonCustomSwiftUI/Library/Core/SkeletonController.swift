import SwiftUI

class SkeletonController: ObservableObject {
    @Published var isAnimating: Bool = false
    
    var animation: SkeletonAnimationType = .pulse
    var baseColor: Color = .gray.opacity(0.3)
    var highlightColor: Color = .gray.opacity(0.6)
    
    var animationView: some View {
        switch animation {
        case .pulse: return AnyView(PulseAnimation(baseColor: baseColor))
        }
    }
    
    func startAnimating() {
        isAnimating = true
    }
    
    func stopAnimating() {
        isAnimating = false
    }
}
