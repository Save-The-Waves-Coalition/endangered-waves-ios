//
//  UserDefaultsHandler.swift
//  Endangered Waves
//
//  Created by Jeffrey Sherin on 3/1/18.
//  Copyright © 2018 Save The Waves. All rights reserved.
//

import Foundation

struct UserDefaultsHandler {

    static let showAlertAfterThisNumberOfLaunches = 10

    private static let hasFiledReport = "HasFiledReport"
    private static let numberOfLaunches = "NumberOfLaunches"

    static func shouldShowSurveryAlert() -> Bool {
        let current = getNumberOfLaunches()
        return current == showAlertAfterThisNumberOfLaunches
    }

    static func getNumberOfLaunches() -> Int {
        return UserDefaults.standard.integer(forKey: numberOfLaunches)
    }

    static func incrementNumberOfLaunches() {
        let current = getNumberOfLaunches()
        UserDefaults.standard.set(current + 1, forKey: numberOfLaunches)
        UserDefaults.standard.synchronize()
    }

}
