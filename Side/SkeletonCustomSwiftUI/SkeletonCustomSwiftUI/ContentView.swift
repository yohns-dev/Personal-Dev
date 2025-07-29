import SwiftUI

//TODO: overlay를 사용해서 기존 view는 안보이게 만들기
//TODO: size 조절할 수 있는 기능 추가하기
//TODO: animaition 효과 추가하기

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
                    .targetSkeleton()
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
