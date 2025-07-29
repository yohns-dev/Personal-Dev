import SwiftUI

struct ShimmerAnimation: View {
    var baseColor: Color
    var highlightColor: Color

    @State private var isAnimating = false

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height

            ZStack {
                baseColor

                LinearGradient(
                    gradient: Gradient(colors: [
                        baseColor,
                        highlightColor,
                        baseColor
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: width * 1.5, height: height)
                .offset(x: isAnimating ? width : -width)
                .onAppear {
                    withAnimation(Animation.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                        isAnimating = true
                    }
                }
            }
            .clipped()
        }
    }
}
