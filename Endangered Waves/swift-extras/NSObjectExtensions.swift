//
//  NSObjectExtensions.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/20/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import Foundation

extension NSObject {
    var className: String {
        return NSStringFromClass(type(of: self))
    }
}
