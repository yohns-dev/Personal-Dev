import SwiftUICore

enum SkeletonAnimationType {
    case pulse
    case shimmer
    case textShimmer(text: String, font: Font? = nil)
    
    func defaultConfig() -> SkeletonAnimationConfig {
        switch self {
        case .pulse:
            return SkeletonAnimationConfig(duration: 1.5, delay: 0, autoreverses: true)
        case .shimmer:
            return SkeletonAnimationConfig(duration: 1.5, delay: 0, autoreverses: false)
        case .textShimmer:
            return SkeletonAnimationConfig(duration: 1.5, delay: 0, autoreverses: true)
        }
    }
}
