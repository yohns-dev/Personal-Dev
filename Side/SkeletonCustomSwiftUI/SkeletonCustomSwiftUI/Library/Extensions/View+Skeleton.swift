import SwiftUI

extension View {
    func targetSkeleton() -> some View {
        self.modifier(TargetSkeletonModifier())
    }
    
    //TODO: 나중에 추가로 애니메이션 컨비규어 따로 만들 수 있도록 하고 아래 함수 두종류로 만들기
    //    func skeletonAnimation(
    //        controller: SkeletonController,
    //        animation: SkeletonAnimationType = .pulse,
    //        baseColor: Color = .gray.opacity(0.3),
    //        highlightColor: Color = .white.opacity(0.6)
    //    ) -> some View {
    //        self.modifier(SkeletonAnimationModifier(controller: controller,animation: animation, baseColor: baseColor, highlightColor: highlightColor))
    //    }
    func skeletonAnimation(controller: SkeletonController) -> some View {
        self.modifier(SkeletonAnimationModifier(controller: controller))
    }
}
