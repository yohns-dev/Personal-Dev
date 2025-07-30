import SwiftUI

struct ShimmerAnimation: View {
    var baseColor: Color
    var highlightColor: Color
    var config: SkeletonAnimationConfig

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
        }
    }
}





//import SwiftUI
//
//struct ShimmerAnimation: View {
//    var baseColor: Color
//    var highlightColor: Color
//    var config: SkeletonAnimationConfig
//
//    @State private var animate = false
//
//    var body: some View {
//            GeometryReader { geometry in
//                let width = geometry.size.width
//                let shimmerWidth = width * 0.6
//
//                ZStack {
//                    baseColor
//
//                    LinearGradient(
//                        gradient: Gradient(colors: [
//                            baseColor,
//                            highlightColor,
//                            baseColor
//                        ]),
//                        startPoint: .leading,
//                        endPoint: .trailing
//                    )
//                    .frame(width: shimmerWidth, height: geometry.size.height)
//                    .offset(x: animate ? width : -shimmerWidth)
//                    .animation(.linear(duration: config.duration).repeatForever(autoreverses: config.autoreverses), value: animate)
//                    
//                    .onAppear {
//                        animate = true
//                    }
//                }
//            }
//        }
//}
