//
//  ReportsListViewController.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/10/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit

class ReportsNavListViewController: NavigationViewController {

}

// MARK: 📖 StoryboardInstantiable
extension ReportsNavListViewController: StoryboardInstantiable {
    static var storyboardName: String { return "list" }
    static var storyboardIdentifier: String? { return "ReportsNavListComponent" }
}
