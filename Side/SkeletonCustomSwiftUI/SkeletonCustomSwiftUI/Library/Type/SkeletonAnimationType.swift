import SwiftUICore

enum SkeletonAnimationType {
    case pulse
    case shimmer
    case textShimmer(text: String, font: Font?)
    
    @ViewBuilder
    func makeView(
        baseColor: Color,
        highlightColor: Color,
        config: SkeletonAnimationConfig
    ) -> some View {
        switch self {
        case .pulse:
            PulseAnimation(baseColor: baseColor, config: config)

        case .shimmer:
            ShimmerAnimation(baseColor: baseColor, highlightColor: highlightColor, config: config)

        case let .textShimmer(text, font):
            TextShimmerAnimation(
                text: text,
                font: font ?? .system(size: 16, weight: .bold),
                baseColor: baseColor,
                highlightColor: highlightColor,
                config: config
            )
        }
    }

    func defaultConfig() -> SkeletonAnimationConfig {
        SkeletonAnimationConfig()
    }
}
