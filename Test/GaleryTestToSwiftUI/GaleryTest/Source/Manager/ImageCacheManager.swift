import SwiftUI

final class ImageCacheManager{
    static let shared = NSCache<NSString, UIImage>()
}
