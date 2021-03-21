//
//  Report.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/11/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import FirebaseFirestore

// Never edit the strings here because they are stored in Firebase and you could break existing records
enum ReportType: String {
    case accessLost = "AccessLost" // V1 Threat Category
    case general = "General" // V1 Threat Category
    case competition = "Competition" // V1 Threat Category
    case wsr = "World Surfing Reserve"

    // Water Quality
    case sewage = "Sewage" // V1 Threat Category
    case runoff = "Runoff"
    case oilSpill = "OilSpill" // V1 Threat Category
    case algalBloom = "AlgalBloom"
    case waterQuality = "WaterQuality"

    // Plastic Trash & Marine Debris
    case plasticPackaging = "PlasticPackaging"
    case microPlastics = "MicroPlastics"
    case fishingGear = "FishingGear"
    case trashed = "Trashed" // V1 Threat Category

    // Coastal Development
    case seawall = "Seawall"
    case hardArmoring = "HardArmoring"
    case beachfrontConstruction = "BeachfrontConstruction"
    case jetty = "Jetty"
    case harbor = "Harbor"
    case coastalDevelopment = "CoastalDevelopment"

    // Sea-Level Rise & Erosion
    case kingTides = "KingTides"
    case coastalErosion = "CoastalErosion" // V1 Threat Category
    case seaLevelRiseAndErosion = "SeaLevelRiseAndErosion"

    // Coral Reef Impacts
    case bleaching = "Bleaching"
    case infrastructure = "Infrastructure"
    case destructiveFishing = "DestructiveFishing"
    case coralReefImpacts = "CoralReefImpacts"

    init() {
        self = .general
    }
}

// swiftlint:disable cyclomatic_complexity
extension ReportType {
    func displayString() -> String {
        switch self {
        case .accessLost: // V1 Threat Category
            return "Access".localized()
        case .general: // V1 Threat Category
            return "General Alert".localized()
        case .competition: // V1 Threat Category
            return "Competition".localized()
        case .wsr:
            return "World Surfing Reserve".localized()

        // Water Quality
        case .sewage: // V1 Threat Category
            return "Sewage Spill".localized()
        case .runoff:
            return "Runoff".localized()
        case .oilSpill: // V1 Threat Category
            return "Oil Spill".localized()
        case .algalBloom:
            return "Algal Bloom".localized()
        case .waterQuality:
            return "Water Quality".localized()

        // Plastic Trash & Marine Debris
        case .plasticPackaging:
            return "Plastic Packaging".localized()
        case .microPlastics:
            return "Micro-plastics".localized()
        case .fishingGear:
            return "Fishing Gear".localized()
        case .trashed: // V1 Threat Category
            return "Trash".localized()

        // Coastal Development
        case .seawall:
            return "Seawall".localized()
        case .hardArmoring:
            return "Hard Armoring".localized()
        case .beachfrontConstruction:
            return "Beachfront Construction".localized()
        case .jetty:
            return "Jetty".localized()
        case .harbor:
            return "Harbor".localized()
        case .coastalDevelopment:
            return "Coastal Development".localized()

        // Sea-Level Rise & Erosion
        case .kingTides:
            return "King Tides".localized()
        case .coastalErosion: // V1 Threat Category
            return "Coastal Erosion".localized()
        case .seaLevelRiseAndErosion:
            return "Sea Level Rise & Erosion".localized()

        // Coral Reef Impacts
        case .bleaching:
            return "Bleaching".localized()
        case .destructiveFishing:
            return "Destructive Fishing".localized()
        case .infrastructure:
            return "Infrastructure".localized()
        case .coralReefImpacts:
            return "Coral Reef Impacts".localized()
        }
    }

    func hashTagString() -> String {
        switch self {
        case .accessLost: // V1 Threat Category
            return "#accesslost"
        case .general: // V1 Threat Category
            return "#general"
        case .competition: // V1 Threat Category
            return "#competition"
        case .wsr:
            return "#worldsurfingreserve"

        // Water Quality
        case .sewage: // V1 Threat Category
            return "#sewagespill"
        case .runoff:
            return "#runoff"
        case .oilSpill: // V1 Threat Category
            return "#oilspill"
        case .algalBloom:
            return "#algalbloom"
        case .waterQuality:
            return "#waterquality"

        // Plastic Trash & Marine Debris
        case .plasticPackaging:
            return "#plasticpackaging"
        case .microPlastics:
            return "#microplastics"
        case .fishingGear:
            return "#fishinggear"
        case .trashed: // V1 Threat Category
            return "#trashed"

        // Coastal Development
        case .seawall:
            return "#seawall"
        case .hardArmoring:
            return "#hardarmoring"
        case .beachfrontConstruction:
            return "#beachfrontconstruction"
        case .jetty:
            return "#jetty"
        case .harbor:
            return "#harbor"
        case .coastalDevelopment:
            return "#coastaldevelopment"

        // Sea-Level Rise & Erosion
        case .kingTides:
            return "#kingtides"
        case .coastalErosion: // V1 Threat Category
            return "#coastalerosion"
        case .seaLevelRiseAndErosion:
            return "#sealevelriseorerosion"

        // Coral Reef Impacts
        case .bleaching:
            return "#bleaching"
        case .destructiveFishing:
            return "#destructivefishing"
        case .infrastructure:
            return "#infrastructure"
        case .coralReefImpacts:
            return "#coralreefimpacts"
        }
    }

    func placemarkIcon() -> UIImage {
        switch self {
        case .accessLost: // V1 Threat Category
            return Style.iconAccessPlacemark
        case .general: // V1 Threat Category
            return Style.iconGeneralPlacemark
        case .competition: // V1 Threat Category
            return Style.iconCompetitionPlacemark
        case .wsr:
            return Style.iconWsrPlacemark

        // Water Quality
        case .oilSpill: // V1 Threat Category
            return Style.iconOilPlacemark
        case .sewage: // V1 Threat Category
            return Style.iconSewagePlacemark
        case .runoff:
            return Style.iconWaterQualityRunoffPlacemark
        case .algalBloom:
            return Style.iconWaterQualityAlgalBloomPlacemark
        case .waterQuality:
            return Style.iconWaterQualityPlacemark

        // Plastic Trash & Marine Debris
        case .plasticPackaging:
            return Style.iconTrashPlasticPackagingPlacemark
        case .microPlastics:
            return Style.iconTrashMicroPlasticsPlacemark
        case .fishingGear:
            return Style.iconTrashFishingGearPlacemark
        case .trashed: // V1 Threat Category
            return Style.iconTrashPlacemark

        // Coastal Development
        case .seawall:
            return Style.iconCoastalDevSeawallPlacemark
        case .hardArmoring:
            return Style.iconCoastalDevHardArmoringPlacemark
        case .jetty:
            return Style.iconCoastalDevJettyPlacemark
        case .harbor:
            return Style.iconCoastalDevHarborPlacemark
        case .beachfrontConstruction:
            return Style.iconCoastalDevConstructionPlacemark
        case .coastalDevelopment:
            return Style.iconCoastalDevelopmentPlacemark

        // Sea-Level Rise & Erosion
        case .kingTides:
            return Style.iconSeaLevelRiseKingTidePlacemark
        case .coastalErosion: // V1 Threat Category
            return Style.iconCoastalErosionPlacemark
        case .seaLevelRiseAndErosion:
            return Style.iconSeaLevelRiseAndErosionPlacemark

        // Coral Reef Impact
        case .destructiveFishing:
            return Style.iconCoralReefImapctFishingPlacemark
        case .bleaching:
            return Style.iconCoralReefImapctBleachingPlacemark
        case .coralReefImpacts:
            return Style.iconCoralReefImapctPlacemark
        case .infrastructure:
            return Style.iconCoralReefImapctInfraPlacemark
        }
    }
}

protocol STWDataType {
    var name: String {get set}
    var coordinate: GeoPoint {get set}
    var description: String {get set}
    var imageURLs: [String] {get set}
    var type: ReportType {get set}
    var address: String {get set}
}

// MARK: 📝 Report

struct Report: STWDataType {
    var name: String
    var coordinate: GeoPoint
    var description: String
    var imageURLs: [String]
    var type: ReportType
    var address: String
    var creationDate: Date
    var user: String

    init(name: String,
         address: String,
         coordinate: GeoPoint,
         creationDate: Date,
         description: String,
         imageURLs: [String],
         type: ReportType,
         user: String) {
        self.name = name
        self.address = address
        self.coordinate = coordinate
        self.creationDate = creationDate
        self.description = description
        self.imageURLs = imageURLs
        self.type = type
        self.user = user
    }

    static func createReportWithDictionary(_ dictionary: [String: Any]) -> Report? {

        guard let name = dictionary["name"] as? String else {
            assertionFailure("⚠️: Name for Report not found")
            return nil
        }

        guard let address = dictionary["address"] as? String else {
            assertionFailure("⚠️: Address for Report not found")
            return nil
        }

        guard let coordinate = dictionary["coordinate"] as? GeoPoint else {
            assertionFailure("⚠️: Coordinate for Report not found")
            return nil
        }

        guard let creation = dictionary["creationDate"] as? Timestamp else {
            assertionFailure("⚠️: CreationDate for Report not found")
            return nil
        }
        let creationDate = creation.dateValue()

        guard let description = dictionary["description"] as? String else {
            assertionFailure("⚠️: Description for Report not found")
            return nil
        }

        guard let imageURLs = dictionary["imageURLs"] as? [String?] else {
            assertionFailure("⚠️: ImageURLs for Report not found")
            return nil
        }

        guard let typeString = dictionary["type"] as? String else {
            assertionFailure("⚠️: TypeString for Report not found")
            return nil
        }

        // Because we are not versioning the API there is potential for there to be
        //  a type in Firebase that the iOS app doesn't recognize. If that happens
        //  let's just fall back to a "general" report type so that the app still works.
        //  In development we throw an assertaion so that the dev can fix this in the
        //  database.
        var type: ReportType
        if let unwrappedType = ReportType(rawValue: typeString) {
            type = unwrappedType
        } else {
            assertionFailure("⚠️: Type \(typeString) for Report not found")
            type = ReportType.general
        }

        guard let user = dictionary["user"] as? String else {
            assertionFailure("⚠️: User for Report not found")
            return nil
        }

        return Report(name: name,
                      address: address,
                      coordinate: coordinate,
                      creationDate: creationDate,
                      description: description,
                      imageURLs: imageURLs.compactMap { $0 }, // new array with all values unwrapped and all nil's filtered away
                      type: type,
                      user: user)
    }
}

extension Report {
    static func createReportWithSnapshot(_ snapshot: DocumentSnapshot) -> Report? {
        guard let snapshotDictionary = snapshot.data() else {
            return nil
        }
        return self.createReportWithDictionary(snapshotDictionary)
    }

    func documentDataDictionary() -> [String: Any] {
        let dataDictionary: [String: Any] = [
            "name": name,
            "address": address,
            "coordinate": coordinate,
            "creationDate": creationDate,
            "description": description,
            "imageURLs": imageURLs,
            "type": type.rawValue,
            "user": user]
        return dataDictionary
    }

    func dateDisplayString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        let dateString = formatter.string(from: creationDate)
        return dateString
    }
}

// MARK: 🌎 WorldSurfingReserve

struct WorldSurfingReserve: STWDataType {
    var name: String
    var coordinate: GeoPoint
    var description: String
    var imageURLs: [String]
    var iconURL: String
    var kmlURL: String?
    var type: ReportType
    var address: String
    var dedicated: Date
    var url: String

    init(name: String,
         address: String,
         coordinate: GeoPoint,
         dedicated: Date,
         description: String,
         imageURLs: [String],
         iconURL: String,
         kmlURL: String?,
         type: ReportType,
         url: String) {
        self.name = name
        self.address = address
        self.coordinate = coordinate
        self.dedicated = dedicated
        self.description = description
        self.imageURLs = imageURLs
        self.iconURL = iconURL
        self.kmlURL = kmlURL
        self.type = type
        self.url = url
    }

    static func createWsrWithDictionary(_ dictionary: [String: Any]) -> WorldSurfingReserve? {

        guard let name = dictionary["name"] as? String else {
            assertionFailure("⚠️: Name of World Surfing Reserve not found")
            return nil
        }

        guard let address = dictionary["address"] as? String else {
                   assertionFailure("⚠️: Name Address of World Surfing Reserve not found")
                   return nil
               }

        guard let coordinate = dictionary["coordinate"] as? GeoPoint else {
            assertionFailure("⚠️: Coordinate for World Surfing Reserve not found")
            return nil
        }

        guard let dedicatedTimestamp = dictionary["dedicated"] as? Timestamp else {
            assertionFailure("⚠️: Dedication Date for World Surfing Reserve not found")
            return nil
        }
        let dedicated = dedicatedTimestamp.dateValue()

        let langCode = Bundle.main.preferredLocalizations[0]
        let description: String
        let firebaseDescriptionKey = "description_\(langCode)"
        if let localizedDescription = dictionary[firebaseDescriptionKey] as? String {
            description = localizedDescription
        } else if let defaultDescription = dictionary["description"] as? String {
            description = defaultDescription
        } else {
            assertionFailure("⚠️: Description for World Surfing Reserve not found")
            return nil
        }

        guard let imageURLs = dictionary["imageURLs"] as? [String?] else {
            assertionFailure("⚠️: ImageURLs for World Surfing Reserve not found")
            return nil
        }

        guard let iconURL = dictionary["iconURL"] as? String else {
            assertionFailure("⚠️: IconURL for World Surfing Reserve not found")
            return nil
        }

        let kmlURL = dictionary["kmlURL"] as? String

        guard let typeString = dictionary["type"] as? String else {
            assertionFailure("⚠️: TypeString for World Surfing Reserve not found")
            return nil
        }

        let type = ReportType(rawValue: typeString) ?? ReportType.general

        guard let url = dictionary["url"] as? String else {
            assertionFailure("⚠️: URL for World Surfing Reserve not found")
            return nil
        }
        return WorldSurfingReserve(name: name,
                                   address: address,
                      coordinate: coordinate,
                      dedicated: dedicated,
                      description: description,
                      imageURLs: imageURLs.compactMap { $0 }, // new array with all values unwrapped and all nil's filtered away
                      iconURL: iconURL,
                      kmlURL: kmlURL,
                      type: type,
                      url: url)
    }
}

extension WorldSurfingReserve {
    static func createWsrWithSnapshot(_ snapshot: DocumentSnapshot) -> WorldSurfingReserve? {
        guard let snapshotDictionary = snapshot.data() else {
            return nil
        }
        return self.createWsrWithDictionary(snapshotDictionary)
    }

    func documentDataDictionary() -> [String: Any] {
        let dataDictionary: [String: Any] = [
            "name": name,
            "address": address,
            "coordinate": coordinate,
            "dedicated": dedicated,
            "description": description,
            "imageURLs": imageURLs,
            "iconURL": iconURL,
            "type": type.rawValue,
            "url": url]
        return dataDictionary
    }
}

extension WorldSurfingReserve {
    func dateDisplayString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        let dateString = formatter.string(from: dedicated)
        return dateString
    }
}
