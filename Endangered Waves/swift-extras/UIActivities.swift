//
//  UIActivities.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/29/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit

class TextActivity: NSObject, UIActivityItemSource {
    private var message: String!

    init(message: String) {
        super.init()
        self.message = message
    }

    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return NSObject()
    }

    func activityViewController(_ activityViewController: UIActivityViewController,
                                itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        if activityType == .postToTwitter || activityType == .postToFacebook {
            return message
        }
        return nil
    }
}

class ImageActivity: NSObject, UIActivityItemSource {
    private var image: UIImage!

    init(image: UIImage) {
        super.init()
        self.image = image
    }

    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return image
    }

    func activityViewController(_ activityViewController: UIActivityViewController,
                                itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return image
    }
}
