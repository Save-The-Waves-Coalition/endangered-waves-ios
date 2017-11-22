//
//  ReportsNavMapViewController.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/10/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit

class ReportsNavMapViewController: NavigationViewController {
}

// MARK: 📖 StoryboardInstantiable
extension ReportsNavMapViewController: StoryboardInstantiable {
    static var storyboardName: String { return "map" }
    static var storyboardIdentifier: String? { return "ReportsNavMapComponent" }
}
