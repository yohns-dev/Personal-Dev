
struct SkeletonAnimationConfig: Equatable {
    var duration: Double = 1.5
    var delay: Double = 0.0
    var autoreverses: Bool = true
    
    static let `default` = SkeletonAnimationConfig()
    
    var isCustomized: Bool {
        self != .default
    }
}

