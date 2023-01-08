import UIKit

/// Used to load assets from Lightbox bundle
class AssetManagerLightbox {

  static func image(_ named: String) -> UIImage? {
      let bundlePath = Bundle.main.path(forResource: "Lightbox", ofType: "bundle")!
      let bundle = Bundle.init(path: bundlePath)
    return UIImage(named: "Lightbox.bundle/\(named)", in: bundle, compatibleWith: nil)
  }
}
