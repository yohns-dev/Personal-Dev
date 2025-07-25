import SwiftUI
import SkeletonUI

struct ContentView: View {
    let listNameItems: [String] = ["One Line Skeleton", "Multi Line Skeleton", "Animation"]
    let listViewItems: [AnyView] =
    [AnyView(SkeletonOneLine()),
     AnyView(SkeletonMultiLine()),
     AnyView(SkeletonAnimation())
    ]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(0..<listNameItems.count, id: \.self) { index in
                    NavigationLink(listNameItems[index]) {
                        listViewItems[index]
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
