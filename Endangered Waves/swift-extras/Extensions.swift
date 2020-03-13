//
//  Extensions.swift
//  Endangered Waves
//
//  Created by Jeffrey Sherin on 3/1/18.
//  Copyright © 2018 Save The Waves. All rights reserved.
//

import UIKit

public extension UIView {

    func pinEdgeAnchorsToView(_ view: UIView, edgeInsets: UIEdgeInsets = UIEdgeInsets.zero) {
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: edgeInsets.left),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: edgeInsets.right),
            topAnchor.constraint(equalTo: view.topAnchor, constant: edgeInsets.top),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: edgeInsets.bottom)
            ])
    }
}

public extension UIImage {
    func mask(with color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        defer { UIGraphicsEndImageContext() }

        guard let context = UIGraphicsGetCurrentContext() else { return self }
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(.normal)

        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        guard let mask = self.cgImage else { return self }
        context.clip(to: rect, mask: mask)

        color.setFill()
        context.fill(rect)

        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return self }
        return newImage
    }

    func scaledToSize(newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
