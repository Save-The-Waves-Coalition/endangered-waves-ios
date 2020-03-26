//
//  WsrReportMapAnnotation.swift
//  Endangered Waves
//
//  Created by Erik Parr on 3/26/20.
//  Copyright © 2020 Save The Waves. All rights reserved.
//  Heavily inspired by Matt Morey

import Foundation
import MapKit

class WsrReportMapAnnotation: NSObject, MKAnnotation {

    var title: String? {
        return "World Surfing Reserve"
    }
    var subtitle: String? {
        return report.description
    }
    let coordinate: CLLocationCoordinate2D
    let report: WsrReport

    init(coordinate: CLLocationCoordinate2D, report: WsrReport) {
        self.coordinate = coordinate
        self.report = report
        super.init()
    }
}
