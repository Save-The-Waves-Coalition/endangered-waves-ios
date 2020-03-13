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
    private static let userEmailAddress = "UserEmailAddress"

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

    static func getUserEmailAddress() -> String? {
        return UserDefaults.standard.string(forKey: userEmailAddress)
    }

    static func setUserEmailAddress(_ emailAddress: String) {
        UserDefaults.standard.set(emailAddress.trimmingCharacters(in: .whitespacesAndNewlines), forKey: userEmailAddress)
        UserDefaults.standard.synchronize()
    }

}
