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
    case oilSpill = "OilSpill"
    case sewage = "Sewage"
    case trashed = "Trashed"
    case coastalErosion = "CoastalErosion"
    case accessLost = "AccessLost"
    case general = "General"
    case competition = "Competition"
    case wsr = "World Surfing Reserve"
    case runoff = "Runoff"
    case algalBloom = "AlgalBloom"
    case waterQuality = "WaterQuality"
    case plasticPackaging = "PlasticPackaging"
    case microPlastics = "MicroPlastics"
    case fishingGear = "FishingGear"
    case seawall = "Seawall"
    case hardArmoring = "HardArmoring"
    case beachfrontConstruction = "BeachfrontConstruction"
    case jetty = "Jetty"
    case harbor = "Harbor"
    case coastalDevelopment = "CoastalDevelopment"
    case kingTides = "KingTides"
    case seaLevelRiseOrFlooding = "SeaLevelRiseOrFlooding"
    case destructiveFishing = "DestructiveFishing"
    case bleaching = "Bleaching"
    case infrastructure = "Infrastructure"
    case coralReefImpacts = "CoralReefImpacts"
    init() {
        self = .general
    }
}

// swiftlint:disable cyclomatic_complexity
extension ReportType {
    func displayString() -> String {
        switch self {
        case .oilSpill:
            return "Oil Spill".localized()
        case .sewage:
            return "Sewage Spill".localized()
        case .trashed:
            return "Trash".localized()
        case .coastalErosion:
            return "Coastal Erosion".localized()
        case .accessLost:
            return "Access".localized()
        case .general:
            return "General Alert".localized()
        case .competition:
            return "Competition".localized()
        case .wsr:
            return "World Surfing Reserve".localized()
        case .runoff:
            return "Runoff".localized()
        case .algalBloom:
            return "Algal Bloom".localized()
        case .waterQuality:
            return "Water Quality".localized()
        case .plasticPackaging:
            return "Plastic Packaging".localized()
        case .microPlastics:
            return "Micro-plastics".localized()
        case .fishingGear:
            return "Fishing Gear".localized()
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
        case .kingTides:
            return "King Tides".localized()
        case .seaLevelRiseOrFlooding:
            return "Sea Level Rise & Erosion".localized()
        case .destructiveFishing:
            return "Destructive Fishing".localized()
        case .bleaching:
            return "Bleaching".localized()
        case .infrastructure:
            return "Infrastructure".localized()
        case .coralReefImpacts:
            return "Coral Reef Impacts".localized()
        }
    }

    func hashTagString() -> String {
        switch self {
        case .oilSpill:
            return "#oilspill"
        case .sewage:
            return "#sewagespill"
        case .trashed:
            return "#trashed"
        case .coastalErosion:
            return "#coastalerosion"
        case .accessLost:
            return "#accesslost"
        case .general:
            return "#general"
        case .competition:
            return "#competition"
        case .wsr:
            return "#worldsurfingreserve"
        case .runoff:
            return "#runoff"
        case .algalBloom:
            return "#algalbloom"
        case .waterQuality:
            return "#waterquality"
        case .plasticPackaging:
            return "#plasticpackaging"
        case .microPlastics:
            return "#microplastics"
        case .fishingGear:
            return "#fishinggear"
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
        case .kingTides:
            return "#kingtides"
        case .seaLevelRiseOrFlooding:
            return "#sealevelriseorflooding"
        case .destructiveFishing:
            return "#destructivefishing"
        case .bleaching:
            return "#bleaching"
        case .infrastructure:
            return "#infrastructure"
        case .coralReefImpacts:
            return "#coralreefimpacts"
        }
    }

    func placemarkIcon() -> UIImage {
        switch self {
        case .accessLost:
            return Style.iconAccessPlacemark
        case .general:
            return Style.iconGeneralPlacemark
        case .competition:
            return Style.iconCompetitionPlacemark
        case .wsr:
            return Style.iconWsrPlacemark

        // Sea-Level Rise & Erosion
        case .kingTides:
            return Style.iconGeneralPlacemark
        case .seaLevelRiseOrFlooding:
            return Style.iconGeneralPlacemark
        case .coastalErosion:
            return Style.iconCoastalErosionPlacemark

        // Water Quality
        case .oilSpill:
            return Style.iconOilPlacemark
        case .sewage:
            return Style.iconSewagePlacemark
        case .runoff:
            return Style.iconWaterQualityRunoffPlacemark
        case .algalBloom:
            return Style.iconWaterQualityAlgalBloomPlacemark
        case .waterQuality:
            return Style.iconWaterQualityPlacemark

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

        // Trash
        case .plasticPackaging:
            return Style.iconTrashPlasticPackagingPlacemark
        case .microPlastics:
            return Style.iconTrashMicroPlasticsPlacemark
        case .fishingGear:
            return Style.iconTrashFishingGearPlacemark
        case .trashed:
            return Style.iconTrashPlacemark

        // Coral Reef Impact
        case .destructiveFishing:
            return Style.iconCoralReefImapctFishingPlacemark
        case .bleaching:
            return Style.iconCoralReefImapctBleachingPlacemark
        case .infrastructure:
            return Style.iconCoralReefImapctInfraPlacemark
        case .coralReefImpacts:
            return Style.iconCoralReefImapctPlacemark
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

        guard let description = dictionary["description"] as? String else {
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
