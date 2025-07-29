import SwiftUICore

enum SkeletonShapeType {
    case rectangle
    case circle
    case capsule
    case rounded(CGFloat)
    
    @ViewBuilder
    func clip<T: View>(_ view: T) -> some View {
        switch self {
        case .rectangle:
            view.clipShape(Rectangle())
        case .circle:
            view.clipShape(Circle())
        case .capsule:
            view.clipShape(Capsule())
        case .rounded(let radius):
            view.clipShape(RoundedRectangle(cornerRadius: radius))
        }
    }
}
