import Foundation

enum SkeletonStackType {
    case vStack(
        spacing: CGFloat = 8,
        alignment: SkeletonStackAlignmentType = .leading
    )
    case hStack(
        spacing: CGFloat = 8,
        alignment: SkeletonStackAlignmentType = .center
    )
}
