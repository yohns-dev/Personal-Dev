import SwiftUI

extension View {
    func targetSkeleton(widthRatio: CGFloat = 1.0, shape: SkeletonShapeType = .rounded(8)) -> some View {
        self.modifier(TargetSkeletonModifier(widthRatio: widthRatio, shape: shape))
    }
    
    //TODO: 나중에 추가로 애니메이션 컨비규어 따로 만들 수 있도록 하고 아래 함수 두종류로 만들기
    func skeletonAnimation(controller: SkeletonController) -> some View {
        self.modifier(SkeletonAnimationModifier(controller: controller))
    }
}
