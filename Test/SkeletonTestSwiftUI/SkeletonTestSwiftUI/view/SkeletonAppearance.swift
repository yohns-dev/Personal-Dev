import SwiftUI
import SkeletonUI

enum AppearanceMode {
    case angular
    case linear
    case radial
    case solid
}

struct SkeletonAppearance: View {
    var listText: [String] = ["angular appearance", "linear appearance", "radial appearance", "solid appearance"]
    var listMode: [AppearanceMode] = [.angular, .linear, .radial, .solid]
    
    var body: some View {
        ScrollView {
            ForEach(0..<listText.count, id: \.self) {index in
                Text(listText[index])
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading, .trailing], 16)
                SkeletonAppearanceCell(mode: listMode[index])
                Divider()
            }
            
            Text("angular circle appearance")
            Circle()
                .skeleton(with: true, appearance: .gradient(.angular, color: .blue, background: .red), shape: .circle)
                .frame(width: 200, height: 200)
            
        }
    }
}

struct SkeletonAppearanceCell: View {
    var appearance: AppearanceType
    
    init(mode: AppearanceMode) {
        switch mode {
        case .angular:
            appearance = .gradient(.angular, color: .blue, background: .red)
        case .linear:
            appearance = .gradient(.linear, color: .blue, background: .red)
        case .radial:
            appearance = .gradient(.radial, color: .blue, background: .red)
        case .solid:
            appearance = .solid(color: .blue, background: .red)
        }
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Text("")
                .font(.system(size: 20, weight: .semibold))
                .skeleton(with: true, size: CGSize(width: CGFloat.infinity, height: 40), appearance: appearance, shape: .capsule, scales: [0: 0.6])
            
            Text("")
                .font(.system(size: 12, weight: .regular))
                .skeleton(with: true, size: CGSize(width: CGFloat.infinity, height: 150), appearance: appearance, shape: .capsule, lines: 5, scales: [1: 0.8, 2: 0.7, 3: 0.9])
        }
        .padding()
    }
}

#Preview {
    SkeletonAppearance()
}
