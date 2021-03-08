//
//  StringExtensions.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 9/10/18.
//  Copyright © 2018 Save The Waves. All rights reserved.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {

        // swiftlint:disable force_try line_length
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        // swiftlint:enable force_try line_length

        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}
