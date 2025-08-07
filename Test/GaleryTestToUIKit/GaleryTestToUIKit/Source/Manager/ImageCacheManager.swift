import UIKit

final class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
}
