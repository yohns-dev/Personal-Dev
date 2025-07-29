import SwiftUI

//TODO: shape, cornerradius


struct ContentView: View {
    private let controller_1 = SkeletonController(animation: .pulse)
    private let contorller_2 = SkeletonController(animation: .pulse, baseColor: .red)
    private let controller_3 = SkeletonController(animation: .pulse)
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                
                RoundedRectangle(cornerRadius: 8)
                    .frame(height: 20)
                    .targetSkeleton()
                
                RoundedRectangle(cornerRadius: 8)
                    .frame(height: 15)
                    .targetSkeleton()
                
                Text("dsa")
                    .frame(height: 30)
                    .targetSkeleton()
            }
            .skeletonAnimation(controller: controller_1)
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
                    .targetSkeleton()
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
                    .targetSkeleton(widthRatio: 2.0)
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
