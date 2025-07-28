import SwiftUI

//TODO: overlay를 사용해서 기존 view는 안보이게 만들기
//TODO: size 조절할 수 있는 기능 추가하기
//TODO: animaition 효과 추가하기

struct ContentView: View {
    var body: some View {
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
        .skeletonAnimation(
            animation: .pulse,
            baseColor: .blue,
            highlightColor: .white.opacity(0.6)
        )
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
        .skeletonAnimation(
            animation: .pulse,
            baseColor: .purple,
            highlightColor: .white.opacity(0.6)
        )
        .padding()
    }
}

#Preview {
    ContentView()
}
