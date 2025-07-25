import SwiftUI
import SkeletonUI

struct User: Identifiable {
    let id = UUID()
    let name: String
}

struct SkeletonLoadingUtility: View {
    @State var users = [User]()
    
    var body: some View {
        VStack {
            SkeletonForEach(with: users, quantity: 5) { loading, user  in
                HStack {
                    Text(user?.name)
                        .skeleton(with: loading, size: CGSize(width: CGFloat.infinity, height: 30))
                }
            }
            SkeletonList(with: users, quantity: 10) { loading, user  in
                HStack {
                    Text(user?.name)
                        .skeleton(with: loading)
                }
                
            }
        }
        .padding()
    }
}


#Preview {
    SkeletonLoadingUtility()
}
