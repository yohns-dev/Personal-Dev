import SwiftUICore

enum SkeletonItem {
    case rectangle(widthRatio: CGFloat, height: CGFloat, cornerRadius: CGFloat)
    case circle(size: CGFloat)
    case spacer(height: CGFloat)

    case hStack(
        spacing: CGFloat = 8,
        alignment: SkeletonStackAlignmentType = .leading,
        items: [SkeletonItem]
    )
    
    case vStack(
        spacing: CGFloat = 8,
        alignment: SkeletonStackAlignmentType = .center,
        items: [SkeletonItem]
    )
}

