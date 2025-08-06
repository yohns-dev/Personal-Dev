import SwiftUI
import Photos

struct GaleryTestThumbnailView: View {
    let asset: PHAsset
    let viewModel: GaleryTestViewModel
    let columns: Int
    
    @State private var image: UIImage?
    @State private var task: Task<Void, Never>? = nil
    
    var body: some View {
        GeometryReader { geometry in
            let width = UIScreen.main.bounds.width / CGFloat(columns)
            let scale = UIScreen.main.scale
            let targetSize = CGSize(width: width * scale, height: width * scale)
            let lowResSize = CGSize(width: 100, height: 100)
            
            let cacheKey = "\(asset.localIdentifier)_\(Int(width))" as NSString
            
            ZStack {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                } else {
                    Color.gray.opacity(0.2)
                }
            }
            .onAppear {
                if let cached = ImageCacheManager.shared.object(forKey: cacheKey) {
                    self.image = cached
                    return
                }
                
                task?.cancel()
                task = Task {
                    if let low = await viewModel.loadImage(for: asset, targetSize: lowResSize) {
                        await MainActor.run {
                            self.image = low
                            ImageCacheManager.shared.setObject(low, forKey: cacheKey)
                        }
                    }
                    
                    if let high = await viewModel.loadImage(for: asset, targetSize: targetSize) {
                        await MainActor.run {
                            self.image = high
                            ImageCacheManager.shared.setObject(high, forKey: cacheKey)
                        }
                    }
                }
            }
            .onDisappear {
                task?.cancel()
            }
        }
        .aspectRatio(1, contentMode: .fill)
        .clipped()
    }
}
