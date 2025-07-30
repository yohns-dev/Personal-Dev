import Foundation

enum SkeletonAnimationType {
    case pulse
    case shimmer
    
    func defaultConfig() -> SkeletonAnimationConfig {
        switch self {
        case .pulse:
            return SkeletonAnimationConfig(duration: 1.5, delay: 0, autoreverses: true)
        case .shimmer:
            return SkeletonAnimationConfig(duration: 1.5, delay: 0, autoreverses: false)
        }
    }
}
