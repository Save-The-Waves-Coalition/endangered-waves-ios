//
//  Style.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/17/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit

struct Style {
    static func fontBrandonGrotesqueBold(size: CGFloat = 16) -> UIFont {
        return UIFont(name: "BrandonGrotesque-Bold", size: size)!
    }

    static func fontBrandonGrotesqueRegular(size: CGFloat = 15) -> UIFont {
        return UIFont(name: "BrandonGrotesque-Regular", size: size)!
    }

    static func fontSFProDisplaySemiBold(size: CGFloat = 16) -> UIFont {
        return UIFont(name: "SFProDisplay-Semibold", size: size)!
    }

    static func fontGeorgiaItalic(size: CGFloat = 15) -> UIFont {
        return UIFont(name: "Georgia-Italic", size: size)!
    }

    static let colorSTWBlue = UIColor(named: "STW-Blue")!
    static let colorSTWGrey = UIColor(named: "STW-Grey")!
}
