import SwiftUI
import Photos

class GaleryTestViewModel: ObservableObject {
    @Published var photoAssets: [PhotoAsset] = []
    
    private let imageManager = PHCachingImageManager()
    
    init() {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized || status == .limited {
                self.fetchPhotos()
            }
        }
    }
    
    private func fetchPhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        var assets: [PhotoAsset] = []
        fetchResult.enumerateObjects { asset, _, _ in
            assets.append(PhotoAsset(id: asset.localIdentifier, asset: asset))
        }
        
        Task { @MainActor in
            self.photoAssets = assets
        }
    }
    
    func loadImage(for asset: PHAsset, targetSize: CGSize) async -> UIImage? {
        await withCheckedContinuation { continuation in
            imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: nil) { image, _ in
                continuation.resume(returning: image)
            }
        }
    }
    
    
}
