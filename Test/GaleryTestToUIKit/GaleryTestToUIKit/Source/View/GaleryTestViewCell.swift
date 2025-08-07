import UIKit
import Photos

final class GaleryTestViewCell: UICollectionViewCell {
    static let reuseIdentifier = "galleryTestViewCell"
    
    private let imageView = UIImageView()
    private let placeholderView = UIView()
    
    private var currentAssetId: String?
    private var loadTask: Task<Void, Never>?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init error")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        placeholderView.isHidden = false
        currentAssetId = nil
        loadTask?.cancel()
    }
    
    func setupUI() {
        contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.frame = contentView.bounds
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        contentView.addSubview(placeholderView)
        placeholderView.frame = contentView.bounds
        placeholderView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        placeholderView.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
    }
    
    
    func configure(with asset: PHAsset, manager: PhotoManager, columns: Int) {
        currentAssetId = asset.localIdentifier
        loadTask?.cancel()
        
        let cellWidth = UIScreen.main.bounds.width / CGFloat(columns)
        let scale = UIScreen.main.scale
        let targetSize = CGSize(width: cellWidth * scale, height: cellWidth * scale)
        let lowSize = CGSize(width: 100, height: 100)
        let cacheKey = "\(asset.localIdentifier)_\(Int(cellWidth))" as NSString
        
        if let cached = ImageCacheManager.shared.object(forKey: cacheKey) {
            self.imageView.image = cached
            placeholderView.isHidden = true
            return
        }
        
        placeholderView.isHidden = false
        
        loadTask = Task {
            if let low = await manager.loadImage(for: asset, targetSize: lowSize) {
                await MainActor.run {
                    guard self.currentAssetId == asset.localIdentifier else { return }
                    self.imageView.image = low
                    placeholderView.isHidden = true
                    ImageCacheManager.shared.setObject(low, forKey: cacheKey)
                }
            }
            
            if let high = await manager.loadImage(for: asset, targetSize: targetSize) {
                await MainActor.run {
                    guard self.currentAssetId == asset.localIdentifier else { return }
                    self.imageView.image = high
                    
                    ImageCacheManager.shared.setObject(high, forKey: cacheKey)
                }
            }
        }
    }
    
}
