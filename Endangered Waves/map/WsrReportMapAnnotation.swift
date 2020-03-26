//
//  ReportMapAnnotation.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/12/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import Foundation
import MapKit

class ReportMapAnnotation: NSObject, MKAnnotation {

    var title: String? {
        return report.name
    }
    var subtitle: String? {
        return report.description
    }
    let coordinate: CLLocationCoordinate2D
    let report: Report

    init(coordinate: CLLocationCoordinate2D, report: Report) {
        self.coordinate = coordinate
        self.report = report
        super.init()
    }
}
