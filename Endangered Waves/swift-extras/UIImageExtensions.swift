//
//  UIImageExtensions.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/23/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit

extension UIImage {
    static func resizeImage(_ image: UIImage, toSize size:CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

        let currentContext = UIGraphicsGetCurrentContext()!
        currentContext.setFillColor(Style.colorSTWGrey.cgColor)
        currentContext.fillEllipse(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))


        let rect = CGRect(x: 2, y: 2, width: size.width - 4, height: size.height - 4)
//        image.draw(in: rect)

        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        return resizedImage
    }
}
