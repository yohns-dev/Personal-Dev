import SwiftUI

struct ShimmerTestView: View {
    @State private var isAnimating = false

    let baseColor: Color = .gray.opacity(0.3)
    let highlightColor: Color = .red

    var body: some View {
        ZStack {
            baseColor

            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height
                let shimmerWidth = width * 1.5

                LinearGradient(
                    gradient: Gradient(colors: [
    
                        baseColor,
                        highlightColor,
                        baseColor
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: shimmerWidth, height: height)
                .offset(x: 10)
//                .onAppear {
//                    isAnimating = false
//                    withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
//                        isAnimating = true
//                    }
//                }
            }
            .clipped()
        }
        .frame(width: 300, height: 24)
        .cornerRadius(8)
        .padding()
    }
}



#Preview {
    ShimmerTestView()
}
