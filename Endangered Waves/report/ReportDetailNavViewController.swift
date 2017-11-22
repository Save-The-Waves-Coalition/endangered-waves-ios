//
//  ReportDetailNavViewController.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/12/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit

class ReportDetailNavViewController: NavigationViewController {
}

// MARK: 📖 StoryboardInstantiable
extension ReportDetailNavViewController: StoryboardInstantiable {
    static var storyboardName: String { return "report" }
    static var storyboardIdentifier: String? { return "ReportDetailNavComponent" }
}
