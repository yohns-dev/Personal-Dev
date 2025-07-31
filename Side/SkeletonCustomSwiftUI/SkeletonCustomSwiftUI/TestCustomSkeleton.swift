import SwiftUI

// TODO: - 스켈레톤이 만들어질 때 기준이 된 아이템을 기준에 만들어지는 것이 아니라 상단에 만들어지는 문제
// TODO: - alignment 수정이 필요

struct TestCustomSkeleton: View {
    @StateObject var controller = SkeletonController(animation: .pulse, baseColor: .red, highlightColor: .green)

    var body: some View {
        VStack(spacing: 20) {
            Text("Real content here")
                .font(.title2)
        }
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
        .onAppear {
            controller.startAnimating()

//            // 시뮬레이션: 3초 뒤 종료
//            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                controller.stopAnimating()
//            }
        }
    }
}

#Preview {
    TestCustomSkeleton()
}
