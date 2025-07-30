import SwiftUICore

private struct SkeletonConfigKey: EnvironmentKey {
    static let defaultValue: SkeletonAnimationConfig? = nil
}

extension EnvironmentValues {
    var skeletonConfig: SkeletonAnimationConfig? {
        get {
            self[SkeletonConfigKey.self]
        }
        set {
            self[SkeletonConfigKey.self] = newValue
        }
    }
}

