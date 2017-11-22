//
//  ImageViewController.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/16/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    var image: UIImage? {
        didSet {
            if let imageView = imageView {
                imageView.image = image
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
}

// MARK: 📖 StoryboardInstantiable
extension ImageViewController: StoryboardInstantiable {
    static var storyboardName: String { return "image-slider" }
    static var storyboardIdentifier: String? { return "ImageViewComponent" }
}
