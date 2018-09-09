//
//  STWButton.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/17/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit

class STWButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // Hack to put the text under the image on a UIButton
    override func layoutSubviews() {

        let spacing: CGFloat = 6.0

        // lower the text and push it left so it appears centered
        //  below the image
        var titleEdgeInsets = UIEdgeInsets.zero
        if let image = self.imageView?.image {
            titleEdgeInsets.left = -image.size.width
            titleEdgeInsets.bottom = -(image.size.height + spacing)
        }
        self.titleEdgeInsets = titleEdgeInsets

        // raise the image and push it right so it appears centered
        //  above the text
        var imageEdgeInsets = UIEdgeInsets.zero
        if let text = self.titleLabel?.text, let font = self.titleLabel?.font {
            let attributes = [NSAttributedStringKey.font: font]
            let titleSize = text.size(withAttributes: attributes)
            imageEdgeInsets.top = -(titleSize.height + spacing)
            imageEdgeInsets.right = -titleSize.width
        }
        self.imageEdgeInsets = imageEdgeInsets

        super.layoutSubviews()
    }

}
