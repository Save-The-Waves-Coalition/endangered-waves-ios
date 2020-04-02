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

    static func fontBrandonGrotesqueBlack(size: CGFloat = 15) -> UIFont {
        return UIFont(name: "BrandonGrotesque-Black", size: size)!
    }

    static func fontSFProDisplaySemiBold(size: CGFloat = 16) -> UIFont {
        return UIFont(name: "SFProDisplay-Semibold", size: size)!
    }

    static func fontGeorgiaItalic(size: CGFloat = 15) -> UIFont {
        return UIFont(name: "Georgia-Italic", size: size)!
    }

    static func fontGeorgia(size: CGFloat = 15) -> UIFont {
        return UIFont(name: "Georgia", size: size)!
    }

    static func userInputAttributedStringForString(_ string: String) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 15
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                          NSAttributedString.Key.font: Style.fontGeorgia(size: 15),
                          NSAttributedString.Key.paragraphStyle: paragraphStyle]
        let newString = NSMutableAttributedString(string: string, attributes: attributes)
        return newString
    }

    static func userInputPlaceholderAttributedStringForString(_ string: String) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 15
        let attributes = [NSAttributedString.Key.foregroundColor: Style.colorSTWGrey,
                          NSAttributedString.Key.font: Style.fontGeorgiaItalic(size: 15),
                          NSAttributedString.Key.paragraphStyle: paragraphStyle]
        let newString = NSMutableAttributedString(string: string, attributes: attributes)
        return newString
    }

    static let colorSTWBlue = UIColor(named: "STW-Blue")!
    static let colorSTWGrey = UIColor(named: "STW-Grey")!

    static let iconOil = UIImage(named: "oil")!
    static let iconCoastalErosion = UIImage(named: "coastal-erosion")!
    static let iconGeneral = UIImage(named: "general")!
    static let iconSewage = UIImage(named: "sewage")!
    static let iconTrash = UIImage(named: "trash")!
    static let iconAccess = UIImage(named: "access")!
    static let iconCompetition = UIImage(named: "competition")!
    static let iconWsr = UIImage(named: "wsr")!

    // Map annotation icons
    static let iconOilPlacemark = UIImage(named: "oil-placemark")!
    static let iconCoastalErosionPlacemark = UIImage(named: "coastal-erosion-placemark")!
    static let iconGeneralPlacemark = UIImage(named: "general-placemark")!
    static let iconSewagePlacemark = UIImage(named: "sewage-placemark")!
    static let iconTrashPlacemark = UIImage(named: "trash-placemark")!
    static let iconAccessPlacemark = UIImage(named: "access-placemark")!
    static let iconCompetitionPlacemark = UIImage(named: "competition-placemark")!
    static let iconWsrPlacemark = UIImage(named: "wsr-placemark")!
    static let wsrPlacemarkers =
        ["Bahía Todos Santos": UIImage(named: "bahia-placemark")!,
         "Noosa, Queensland": UIImage(named: "noosa-placemark")!,
         "Gold Coast: Snapper": UIImage(named: "gold-placemark")!,
         "Gold Coast: Burleigh": UIImage(named: "gold-placemark")!,
         "Huanchaco": UIImage(named: "huanchacho-placemark")!,
         "Manly Beach": UIImage(named: "manly-placemark")!,
         "Guarda do Embaú": UIImage(named: "guarda-placemark")!,
         "Punta de Lobos": UIImage(named: "punta-placemark")!,
         "Punta Borinquen": UIImage(named: "punta-placemark")!,
         "Malibu, California": UIImage(named: "malibu-placemark")!,
         "Santa Cruz, California": UIImage(named: "santa-placemark")!,
         "Ericeira": UIImage(named: "ericeira-placemark")!
    ]
}
