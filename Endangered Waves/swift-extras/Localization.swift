//
//  Localization.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 3/12/21.
//  Copyright © 2021 Save The Waves. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func localized() -> String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}

final class UILocalizedLabel: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        text = text?.localized()
    }
}

final class UILocalizedButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()

        if let title = self.title(for: .normal) {
            setTitle(title.localized(), for: .normal)
        } else if let attributedTitle = self.attributedTitle(for: .normal) {
            let title = attributedTitle.string
            let range = NSRange(location: 0, length: attributedTitle.length)
            let attributes = attributedTitle.attributes(at: 0, longestEffectiveRange: nil, in: range)
            let newAttributedTitle = NSAttributedString(string: title.localized(), attributes: attributes)
            setAttributedTitle(newAttributedTitle, for: .normal)
        }
    }
}

final class UILocalizedBarButtonItem: UIBarButtonItem {
    override func awakeFromNib() {
        super.awakeFromNib()
        title = title?.localized()
    }
}
