import SwiftUI
import SkeletonUI

struct SkeletonOneLine: View {
    @State var isShowingSkeleton: Bool = false
    
    var body: some View {
        ScrollView {
            ForEach(0..<10) { _ in
                SkeletonOneLineCell(isShowingSkeleton: $isShowingSkeleton)
            }
        }
        
        Spacer()
        
        Button(isShowingSkeleton ? "스켈레톤 숨기기" : "스켈레톤 보기") {
            self.isShowingSkeleton.toggle()
        }
    }
}


// MARK: test view cell
struct SkeletonOneLineCell: View {
    @Binding var isShowingSkeleton: Bool
    
    var body: some View {
        VStack {
            Image(systemName: "list.bullet.rectangle.fill")
                .resizable()
                .skeleton(with: isShowingSkeleton, shape: .rectangle)
                .frame(height: 200)
            
            Spacer()
            
            Text("test title text")
                .frame(maxWidth: .infinity, alignment: .leading)
                .skeleton(with: isShowingSkeleton, shape: .rectangle)
            
            Spacer()
            
            Text("test subtitle text")
                .frame(maxWidth: .infinity, alignment: .leading)
                .skeleton(with: isShowingSkeleton, shape: .rectangle, scales: [0 : 0.7])
            Spacer()
        }
        .frame(height: 300)
        .padding()
    }
}

#Preview {
    SkeletonOneLine()
}
