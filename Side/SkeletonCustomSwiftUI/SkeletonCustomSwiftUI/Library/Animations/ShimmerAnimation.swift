import SwiftUI

struct ShimmerAnimation: View {
    var baseColor: Color
    var highlightColor: Color
    var speed: Double = 1.0

    @State private var move = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                baseColor

                LinearGradient(
                    gradient: Gradient(colors: [baseColor, highlightColor, baseColor]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: geometry.size.width * 2)
                .offset(x: move ? -geometry.size.width : geometry.size.width)
                .onAppear {
                    withAnimation(Animation.linear(duration: speed).repeatForever(autoreverses: false)) {
                        move = true
                    }
                }
            }
            .clipped()
        }
    }
}
