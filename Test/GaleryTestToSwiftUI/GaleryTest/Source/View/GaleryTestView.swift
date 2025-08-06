import SwiftUI
import Photos

struct GaleryTestView: View {
    @StateObject private var viewModel = GaleryTestViewModel()
    @State private var columns: Int = 3
    @State private var lastScaleValue: CGFloat = 1.0

    let minColumns = 1
    let maxColumns = 6

    var body: some View {
        let gridItems = Array(repeating: GridItem(.flexible(), spacing: 2), count: columns)

        ScrollView {
            LazyVGrid(columns: gridItems, spacing: 2) {
                ForEach(viewModel.photoAssets) { photo in
                    GaleryTestThumbnailView(asset: photo.asset, viewModel: viewModel, columns: columns)
                        .aspectRatio(1, contentMode: .fill)
                        .clipped()
                }
            }
            .padding(2)
        }
        .gesture(
            MagnificationGesture()
                .onChanged { value in
                    let delta = value / lastScaleValue
                    lastScaleValue = value

                    if delta > 1.1 {
                        if columns > minColumns {
                            columns -= 1
                        }
                        lastScaleValue = 1.0
                    } else if delta < 0.9 {
                        if columns < maxColumns {
                            columns += 1
                        }
                        lastScaleValue = 1.0
                    }
                }
                .onEnded { _ in
                    lastScaleValue = 1.0
                }
        )
        .animation(.easeInOut, value: columns)
    }
}






