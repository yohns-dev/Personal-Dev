import SwiftUI

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
                    .targetSkeleton(widthRatio: 0.6,alignment: .trailing)
                
                RoundedRectangle(cornerRadius: 8)
                    .frame(height: 15)
                    .targetSkeleton(widthRatio: 0.5, alignment: .leading)
                
                Text("dsa")
                    .frame(height: 30)
                    .targetSkeleton()
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
