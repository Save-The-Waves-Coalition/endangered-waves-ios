//
//  ContainerNavViewController.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/25/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit

class ContainerNavViewController: NavigationViewController {

}

// MARK: 📖 StoryboardInstantiable
extension ContainerNavViewController: StoryboardInstantiable {
    static var storyboardName: String { return "container" }
    static var storyboardIdentifier: String? { return "ContainerNavComponent" }
}
