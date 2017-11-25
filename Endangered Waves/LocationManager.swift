//
//  LocationManager.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/23/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    let manager = CLLocationManager()
    private var completion: ((CLLocation) -> Void)?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func getCurrentLocation(completion: @escaping (CLLocation) -> Void) {
        self.completion = completion
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        if let userLocation = locations.last, let completion = self.completion {
            completion(userLocation)
        }
    }
}
