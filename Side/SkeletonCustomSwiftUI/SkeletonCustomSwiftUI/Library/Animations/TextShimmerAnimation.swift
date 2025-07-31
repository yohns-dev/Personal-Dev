import SwiftUI

struct TextShimmerAnimation: View {
    var text: String
    var font: Font
    var baseColor: Color
    var highlightColor: Color
    var config: SkeletonAnimationConfig

    @State private var animate = false

    var body: some View {
        Text(text)
            .font(font)
            .foregroundColor(baseColor)
            .overlay(shimmerOverlay)
            .mask(
                Text(text)
                    .font(font)
            )
            .onAppear {
                Task {
                    if config.delay > 0 {
                        try await Task.sleep(nanoseconds: UInt64(config.delay * 1_000_000_000))
                    }
                    withAnimation(
                        .linear(duration: config.duration)
                            .repeatForever(autoreverses: config.autoreverses)
                    ) {
                        animate = true
                    }
                }
            }
    }

    var shimmerOverlay: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            LinearGradient(
                gradient: Gradient(colors: [
                    baseColor,
                    highlightColor,
                    baseColor
                ]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: 100, height: geometry.size.height)
            .offset(x: animate ? width : -100)
        }
    }
}
