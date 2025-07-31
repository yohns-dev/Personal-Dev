import SwiftUI

//TODO: 특정 View에 커스텀 Skeleton적용할 수 있게 만들기
//예를 들면 VStack{}.custonAnimation(controller: controller, place: [.rectangel(1.0), .rectangel(0.2), .rectangel(0.8)], stack: .HStack, alignmnet: [.leading, .center]) 이런식으로 적용하면 간단하게 그려줄 수 있도록 단 이 부분은 크기조절하는 것을 어떻게 해야할 지 고민할 것
//TODO: 높이 비율로 조절할 수 있도록 하기


struct ContentView: View {
    private let controller_1 = SkeletonController(animation: .shimmer, baseColor: .red, highlightColor: .blue)
    private let contorller_2 = SkeletonController(animation: .pulse, baseColor: .red)
    private let controller_3 = SkeletonController(animation: .textShimmer(text: "loading...", font: .system(size: 15, weight: .bold)), baseColor: .cyan, highlightColor: .brown)
    
//    private let config_1 = SkeletonAnimationConfig(duration: 2, delay: 0.2, autoreverses: false)
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                
                RoundedRectangle(cornerRadius: 8)
                    .frame(height: 20)
                    .targetSkeleton(widthRatio: 0.6, alignment: .trailing)
                
                RoundedRectangle(cornerRadius: 8)
                    .frame(height: 15)
                    .targetSkeleton()
                
                Text("dsa")
                    .frame(height: 30)
                    .targetSkeleton(alignment: .leading)
            }
//            .skeletonAnimationConfig(config_1)
            .skeletonAnimation(controller: controller_1)
            .padding()
            
            VStack(spacing: 16) {
                RoundedRectangle(cornerRadius: 8)
                    .frame(height: 20)
                    .targetSkeleton()
                    .skeletonAnimationConfig(duration: 5, delay: 3)
                
                RoundedRectangle(cornerRadius: 8)
                    .frame(height: 15)
                    .targetSkeleton()
                
                Text("dsa")
                    .frame(height: 30)
                    .targetSkeleton()
                    .skeletonAnimationConfig(duration: 5, delay: 3)
            }
            
            .skeletonAnimation(controller: contorller_2)
            .padding()
            
            VStack(spacing: 16) {
                RoundedRectangle(cornerRadius: 8)
                    .frame(height: 20)
                    .targetSkeleton()
                
                RoundedRectangle(cornerRadius: 8)
                    .frame(height: 15)
                    .targetSkeleton()
                
                Text("dsa")
                    .frame(height: 30)
                    .targetSkeleton(widthRatio: 2.0, alignment: .trailing)
            }
            .skeletonAnimation(controller: controller_3)
            .padding()
            
            HStack {
                Button("Start") {
                    controller_1.startAnimating()
                }
                Button("Stop") {
                    controller_1.stopAnimating()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
