import SwiftUI

struct ColoredShimmerView: View {
    @State private var animate = false

    var body: some View {
        Rectangle()
//        Text("Loading...")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.gray)
            .overlay(
                shimmerOverlay
            )
//            .mask( shimmerOverlay )
//            .mask(
//                Text("Loading...")
//                    .font(.largeTitle)
//                    .fontWeight(.bold)
//            )
            .onAppear {
                withAnimation(
                    .linear(duration: 1.5)
                    .repeatForever(autoreverses: false)
                ) {
                    animate = true
                }
            }
    }

    var shimmerOverlay: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.red.opacity(0.7),
                    Color.orange,
                    Color.red.opacity(0.7)
                ]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: 100, height: geometry.size.height)
            .offset(x: animate ? width - 100 : -width - 20)
        }
    }
}


struct testView: View {
    var body: some View {
        VStack {
            ColoredShimmerView()
                .frame(width: 200, height: 40)
        }
    }
}


#Preview {
    testView()
}
