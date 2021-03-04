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

extension ReportType {
    func displayString() -> String {
        switch self {
        case .oilSpill:
            return "Oil Spill"
        case .sewage:
            return "Sewage Spill"
        case .trashed:
            return "Trash"
        case .coastalErosion:
            return "Coastal Erosion"
        case .accessLost:
            return "Beach Access"
        case .general:
            return "General Alert"
        case .competition:
            return "Competition"
        case .wsr:
            return "World Surfing Reserve"
        case .runoff:
            return "Runoff"
        case .algalBloom:
            return "Algal Bloom"
        case .waterQuality:
            return "Water Quality"
        case .plasticPackaging:
            return "Plastic Packaging"
        case .microPlastics:
            return "Micro-plastics"
        case .fishingGear:
            return "Fishing Gear"
        case .seawall:
            return "Seawall"
        case .hardArmoring:
            return "Hard Armoring"
        case .beachfrontConstruction:
            return "Beachfront Construction"
        case .jetty:
            return "Jetty"
        case .harbor:
            return "Harbor"
        case .coastalDevelopment:
            return "Coastal Development"
        case .kingTides:
            return "King Tides"
        case .seaLevelRiseOrFlooding:
            return "Sea Level Rise or Flooding"
        case .destructiveFishing:
            return "Destructive Fishing"
        case .bleaching:
            return "Bleaching"
        case .infrastructure:
            return "Infrastructure"
        case .coralReefImpacts:
            return "Coral Reef Impacts"
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
        case .oilSpill:
            return Style.iconOilPlacemark
        case .sewage:
            return Style.iconSewagePlacemark
        case .trashed:
            return Style.iconTrashPlacemark
        case .coastalErosion:
            return Style.iconCoastalErosionPlacemark
        case .accessLost:
            return Style.iconAccessPlacemark
        case .general:
            return Style.iconGeneralPlacemark
        case .competition:
            return Style.iconCompetitionPlacemark
        case .wsr:
            return Style.iconWsrPlacemark
        case .runoff:
            return Style.iconGeneralPlacemark
        case .algalBloom:
            return Style.iconGeneralPlacemark
        case .waterQuality:
            return Style.iconGeneralPlacemark
        case .plasticPackaging:
            return Style.iconGeneralPlacemark
        case .microPlastics:
            return Style.iconGeneralPlacemark
        case .fishingGear:
            return Style.iconGeneralPlacemark
        case .seawall:
            return Style.iconGeneralPlacemark
        case .hardArmoring:
            return Style.iconGeneralPlacemark
        case .beachfrontConstruction:
            return Style.iconGeneralPlacemark
        case .jetty:
            return Style.iconGeneralPlacemark
        case .harbor:
            return Style.iconGeneralPlacemark
        case .coastalDevelopment:
            return Style.iconGeneralPlacemark
        case .kingTides:
            return Style.iconGeneralPlacemark
        case .seaLevelRiseOrFlooding:
            return Style.iconGeneralPlacemark
        case .destructiveFishing:
            return Style.iconGeneralPlacemark
        case .bleaching:
            return Style.iconGeneralPlacemark
        case .infrastructure:
            return Style.iconGeneralPlacemark
        case .coralReefImpacts:
            return Style.iconGeneralPlacemark
        }
    }

    func icon() -> UIImage {
        switch self {
        case .oilSpill:
            return Style.iconOil
        case .sewage:
            return Style.iconSewage
        case .trashed:
            return Style.iconTrash
        case .coastalErosion:
            return Style.iconCoastalErosion
        case .accessLost:
            return Style.iconAccess
        case .general:
            return Style.iconGeneral
        case .competition:
            return Style.iconCompetition
        case .wsr:
            return Style.iconWsr
        case .runoff:
            return Style.iconGeneral
        case .algalBloom:
            return Style.iconAlgalBloom
        case .waterQuality:
            return Style.iconWaterQuality
        case .plasticPackaging:
            return Style.iconGeneral
        case .microPlastics:
            return Style.iconGeneral
        case .fishingGear:
            return Style.iconGeneral
        case .seawall:
            return Style.iconGeneral
        case .hardArmoring:
            return Style.iconGeneral
        case .beachfrontConstruction:
            return Style.iconGeneral
        case .jetty:
            return Style.iconGeneral
        case .harbor:
            return Style.iconGeneral
        case .coastalDevelopment:
            return Style.iconCoastalDevelopment
        case .kingTides:
            return Style.iconGeneral
        case .seaLevelRiseOrFlooding:
            return Style.iconSeaLevelRiseOrFlooding
        case .destructiveFishing:
            return Style.iconGeneral
        case .bleaching:
            return Style.iconGeneral
        case .infrastructure:
            return Style.iconGeneral
        case .coralReefImpacts:
            return Style.iconCoralReefImpacts
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
    var creationDate: Date? {get set}
    var url: String? {get set}
}

struct Report: STWDataType {
    var name: String
    var coordinate: GeoPoint
    var description: String
    var imageURLs: [String]
    var type: ReportType
    var address: String
    var creationDate: Date?
    var user: String?
    var url: String?

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

        // TODO: 2020-03-14 MDM We need to define what the various types are, it matters for iOS currently,
        //                      we could just make it fall back to general and be done with it ¯\(°_o)/¯
        let type = ReportType(rawValue: typeString) ?? ReportType.general
//        guard let type = ReportType(rawValue: typeString) else {
//            assertionFailure("⚠️: Type for Report not found")
//            return nil
//        }

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

struct WorldSurfingReserve: STWDataType {
    var name: String
    var coordinate: GeoPoint
    var description: String
    var imageURLs: [String]
    var iconURL: String
    var kmlURL: String?
    var type: ReportType
    var creationDate: Date?
    var address: String
    var dedicated: Date?
    var url: String?

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

extension Report {
    static func createReportWithSnapshot(_ snapshot: DocumentSnapshot) -> Report? {
        // TODO: Fix this "!"
        return self.createReportWithDictionary(snapshot.data()!)
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
}

extension STWDataType {
    func dateDisplayString() -> String {
        if let creationDate = creationDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            let dateString = formatter.string(from: creationDate)
            return dateString
        } else {
            return ""
        }
    }
}

extension WorldSurfingReserve {
    static func createWsrWithSnapshot(_ snapshot: DocumentSnapshot) -> WorldSurfingReserve? {
        // TODO: Fix this "!"
        return self.createWsrWithDictionary(snapshot.data()!)
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
        if let dedicated = dedicated {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        let dateString = formatter.string(from: dedicated)
        return dateString
        } else {
            print("Dedication Date for World Surfing Reserve not found")
            return ""
        }
    }
}
