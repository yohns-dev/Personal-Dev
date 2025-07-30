
import SwiftUI

struct PulseAnimation: View {
    var baseColor: Color
    var config: SkeletonAnimationConfig

    @State private var animate = false

    var body: some View {
        baseColor
            .opacity(animate ? 0.4 : 1.0)
            .animation(
                Animation.easeInOut(duration: config.duration)
                    .delay(config.delay)
                    .repeatForever(autoreverses: config.autoreverses),
                value: animate
            )
            .onAppear {
                animate = true
            }
    }
}
