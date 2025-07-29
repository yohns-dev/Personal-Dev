
import SwiftUI

struct PulseAnimation: View {
    var baseColor: Color
    var speed: Double = 0.6
    

    @State private var animate = false

    var body: some View {
        baseColor
            .opacity(animate ? 0.4 : 1.0)
            .animation(
                Animation.easeInOut(duration: speed)
                    .repeatForever(autoreverses: true),
                value: animate
            )
            .onAppear {
                animate = true
            }
    }
}
