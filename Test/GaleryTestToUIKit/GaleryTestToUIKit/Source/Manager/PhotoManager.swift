import Photos
import UIKit

final class PhotoManager {
    private let imageManager = PHCachingImageManager()
    private(set) var assets: [PHAsset] = []
    
    func requestPermission() async -> Bool {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        if status == .authorized || status == .limited {
            self.fetchPhotos()
            return true
        }
        else {
            return false
        }
    }
    
    private func fetchPhotos() {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult = PHAsset.fetchAssets(with: .image, options: options)
        fetchResult.enumerateObjects { asset, _, _ in
            self.assets.append(asset)
        }
    }
    
    func requestImage(for asset: PHAsset, size: CGSize, completion: @escaping (UIImage?) -> Void) {
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .opportunistic
        options.resizeMode = .fast
        
        imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: options) {
            image, _ in
            completion(image)
        }
    }
    
    func loadImage(for asset: PHAsset, targetSize: CGSize) async -> UIImage? {
        await withCheckedContinuation { continuation in
            let options = PHImageRequestOptions()
            options.isSynchronous = false
            options.deliveryMode = .opportunistic
            options.resizeMode = .fast
            
            imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { image, _ in
                continuation.resume(returning: image)
            }
        }
    }
}
