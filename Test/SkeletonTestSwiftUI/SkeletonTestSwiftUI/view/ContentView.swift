import SwiftUI
import SkeletonUI

struct ContentView: View {
    let listNameItems: [String] = ["One Line Skeleton"]
    let listViewItems: [AnyView] = [AnyView(SkeletonOneLine())]
    
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
