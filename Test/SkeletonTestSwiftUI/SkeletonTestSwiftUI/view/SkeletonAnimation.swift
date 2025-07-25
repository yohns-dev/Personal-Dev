import SwiftUI
import SkeletonUI

struct SkeletonAnimation: View {
    var body: some View {
        ScrollView {
            Text("한 방향 Linear Animation")
            Text("")
                .skeleton(with: true, size: CGSize(width: CGFloat.infinity, height: 30), animation: .linear(duration: 1.0, delay: 0.2, speed: 0.4, autoreverses: false))
            
            Text("완복 Linear Animation")
            Text("")
                .skeleton(with: true, size: CGSize(width: CGFloat.infinity, height: 30), animation: .linear(duration: 1.0, delay: 0.2, speed: 0.4, autoreverses: true))
            
            Text("완복 Circle Linear Animation")
            Circle()
                .skeleton(with: true, animation: .linear(duration: 1.0, delay: 0.2, speed: 0.4, autoreverses: true))
                .frame(width: 100, height: 100)
            
            Divider()
            
            Text("한 방향 Pulse Animation")
            Text("")
                .skeleton(with: true, size: CGSize(width: CGFloat.infinity, height: 30), animation: .pulse(duration: 1.0, delay: 0.2, speed: 0.4, autoreverses: false))
            
            Text("완복 Pulse Animation")
            Text("")
                .skeleton(with: true, size: CGSize(width: CGFloat.infinity, height: 30), animation: .pulse(duration: 1.0, delay: 0.2, speed: 0.4, autoreverses: true))
            
            Text("완복 Circle Pulse Animation")
            Circle()
                .skeleton(with: true, animation: .pulse(duration: 1.0, delay: 0.2, speed: 0.4, autoreverses: true))
                .frame(width: 100, height: 100)
            
            Divider()
            
            Text("None")
            Text("")
                .skeleton(with: true, size: CGSize(width: CGFloat.infinity, height: 30), animation: .none)
            
            Text("완복 Pulse Animation")
            Text("")
                .skeleton(with: true, size: CGSize(width: CGFloat.infinity, height: 30), animation: .none)
            
            Text("완복 Circle Pulse Animation")
            Circle()
                .skeleton(with: true, animation: .none)
                .frame(width: 100, height: 100)
        }
    }
}

#Preview {
    SkeletonAnimation()
}
