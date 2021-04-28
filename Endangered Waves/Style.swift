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
    static let iconAlgalBloom = UIImage(named: "algae_blooms")!
    static let iconWaterQuality = UIImage(named: "water_quality")!
    static let iconCoastalDevelopment = UIImage(named: "coastal_development")!
    static let iconSeaLevelRiseOrFlooding = UIImage(named: "sea_level_rise")!
    static let iconCoralReefImpacts = UIImage(named: "coral-reef")!

    //
    // Map annotation icons
    //
    static let iconGeneralPlacemark = UIImage(named: "general-placemark")!
    static let iconAccessPlacemark = UIImage(named: "access-placemark")!
    static let iconCompetitionPlacemark = UIImage(named: "competition-placemark")!
    static let iconWsrPlacemark = UIImage(named: "wsr-placemark")!

    // Sea-Level Rise & Erosion
    static let iconCoastalErosionPlacemark = UIImage(named: "coastal-erosion-placemark")!
    static let iconSeaLevelRiseKingTidePlacemark = UIImage(named: "sealevel-rise-and-erosion-kingtide-placemark")!
    static let iconSeaLevelRiseAndErosionPlacemark = UIImage(named: "sealevel-rise-and-erosion-placemark")!

    // Water Quality
    static let iconOilPlacemark = UIImage(named: "oil-placemark")!
    static let iconSewagePlacemark = UIImage(named: "sewage-placemark")!
    // Missing Runoff
    static let iconWaterQualityAlgalBloomPlacemark = UIImage(named: "water-quality-algal-bloom-placemark")!
    static let iconWaterQualityPlacemark = UIImage(named: "water-quality-placemark")!

    // Coastal Development
    static let iconCoastalDevHarborPlacemark = UIImage(named: "coastal-develeopment-harbor-placemark")!
    static let iconCoastalDevHardArmoringPlacemark = UIImage(named: "coastal-development-hard-armoring-placemark")!
    static let iconCoastalDevSeawallPlacemark = UIImage(named: "coastal-development-seawall-placemark")!
    static let iconCoastalDevJettyPlacemark = UIImage(named: "coastal-development-jetty-placemark")!
    static let iconCoastalDevConstructionPlacemark = UIImage(named: "coastal-development-beachfront-construction-placemark")!
    static let iconCoastalDevelopmentPlacemark = UIImage(named: "coastal-development-placemark")!

    // Coral Reef Impact
    static let iconCoralReefImapctBleachingPlacemark = UIImage(named: "coral-reef-impact-bleaching-placemark")!
    static let iconCoralReefImapctFishingPlacemark = UIImage(named: "coral-reef-impact-destructive-fishing-placemark")!
    static let iconCoralReefImapctInfraPlacemark = UIImage(named: "coral-reef-impact-infrastructure-placemark")!
    static let iconCoralReefImapctPlacemark = UIImage(named: "coral-reef-impact-placemark")!

    // Trash
    static let iconTrashFishingGearPlacemark = UIImage(named: "trash-fishing-gear-placemark")!
    static let iconTrashPlasticPackagingPlacemark = UIImage(named: "trash-plastic-packaging-placemark")!
    static let iconTrashMicroPlasticsPlacemark = UIImage(named: "trash-microplastics-placemark")!
    static let iconTrashPlacemark = UIImage(named: "trash-placemark")!

    // Missing
    static let iconWaterQualityRunoffPlacemark = UIImage(named: "sewage-placemark")!
}
