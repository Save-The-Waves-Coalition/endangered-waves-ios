//
//  NewReportNavViewController.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/14/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit

class NewReportNavViewController: NavigationViewController {

}

// MARK: 📖 StoryboardInstantiable
extension NewReportNavViewController: StoryboardInstantiable {
    static var storyboardName: String { return "new-report" }
    static var storyboardIdentifier: String? { return "NewReportNavComponent" }
}

