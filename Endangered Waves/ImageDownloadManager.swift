//
//  ImageDownloadManager.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/25/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit
import SDWebImage

class ImageDownloadManager: NSObject {
    let manager = SDWebImageManager.shared
    private var images: [UIImage] = [UIImage]()
    private var processed: Int = 0
    private var total: Int = 0

    override init() {
        super.init()
    }

    func loadImagesWithURLs(_ urls: [URL], completion: @escaping ([UIImage]) -> Void) {
        images = [UIImage]()
        processed = 0
        total = urls.count

        for url in urls {
            manager.loadImage(with: url, options: [], progress: nil, completed: { (image, data, error, cacheType, finished, imageURL) in

                self.processed += 1

                if let image = image {
                    self.images.append(image)
                }

                // Check if all images have been downloaded
                if self.processed == self.total {
                    completion(self.images)
                }
            })
        }
    }
}
