import SwiftUI

// TODO: - alignment 수정이 필요

struct TestCustomSkeleton: View {
    @StateObject var controller = SkeletonController(animation: .pulse, baseColor: .red, highlightColor: .green)

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Real content here")
                .border(Color.gray)
                .font(.title2)
                .customSkeleton(
                    controller: controller,
                    place: [
                        .rectangle(widthRatio: 1.0, height: 24, cornerRadius: 8), 
                        .spacer(height: 12),
                        .hStack(spacing: 12, alignment: .bottom, items: [
                            .circle(size: 40),
                            .rectangle(widthRatio: 0.7, height: 16, cornerRadius: 6)
                        ])
                    ],
                    stack: .vStack(spacing: 16, alignment: .bottom)
                )
                .padding()
            
            Text("Real content here")
                .border(Color.gray)
                .font(.title2)
                .customSkeleton(
                    controller: controller,
                    place: [
                        .rectangle(widthRatio: 1.0, height: 24, cornerRadius: 8),
                        .spacer(height: 12),
                        .hStack(spacing: 12, alignment: .bottom, items: [
                            .circle(size: 40),
                            .rectangle(widthRatio: 0.7, height: 16, cornerRadius: 6)
                        ])
                    ],
                    stack: .vStack(spacing: 16, alignment: .bottom)
                )
                .padding()
            
            Spacer()
            
        }
        .onAppear {
            controller.startAnimating()
//            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                controller.stopAnimating()
//            }
        }
        .border(Color.gray)
    }
}

#Preview {
    TestCustomSkeleton()
}
