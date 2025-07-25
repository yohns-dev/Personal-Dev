import SwiftUI
import SkeletonUI

struct SkeletonMultiLine: View {
    var body: some View {
        ScrollView {
            ForEach(0..<10, id: \.self) { _ in
                SkeletonMultiLineCell()
                Divider()
                
            }
        }
    }
}

struct SkeletonMultiLineCell: View {
    var body: some View {
        VStack(spacing: 30) {
            Text("")
                .font(.system(size: 20, weight: .semibold))
                .skeleton(with: true, size: CGSize(width: CGFloat.infinity, height: 40), shape: .capsule, scales: [0: 0.6])
            
            Text("")
                .font(.system(size: 12, weight: .regular))
                .skeleton(with: true, size: CGSize(width: CGFloat.infinity, height: 150), shape: .capsule, lines: 5, scales: [1: 0.8, 2: 0.7, 3: 0.9])
        }
        .padding()
    }
}

#Preview {
    SkeletonMultiLine()
}
