//
//  ContainerNavViewController.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/10/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit

class ContainerNavViewController: NavigationViewController {

}

extension ContainerNavViewController: StoryboardInstantiable {
    static var storyboardName: String { return "container" }
    static var storyboardIdentifier: String? { return "ContainerNavComponent" }
}
