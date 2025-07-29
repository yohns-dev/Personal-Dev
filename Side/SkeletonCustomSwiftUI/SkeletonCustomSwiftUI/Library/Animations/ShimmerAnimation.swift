import SwiftUI

struct ShimmerAnimation: View {
    var baseColor: Color
    var highlightColor: Color

    @State private var animate = false

    var body: some View {
            GeometryReader { geometry in
                let width = geometry.size.width
                let shimmerWidth = width * 0.6

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
                    .frame(width: shimmerWidth, height: geometry.size.height)
                    .offset(x: animate ? width : -shimmerWidth)
                    .animation(.linear(duration: 1.2).repeatForever(autoreverses: false), value: animate)
                    .onAppear {
                        animate = true
                    }
                }
            }
        }
}
