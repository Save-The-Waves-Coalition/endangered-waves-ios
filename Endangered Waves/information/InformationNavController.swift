//
//  InformationNavController.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/21/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

class InformationNavController: NavigationViewController {
}

extension InformationNavController: StoryboardInstantiable {
    static var storyboardName: String { return "information" }
    static var storyboardIdentifier: String? { return "InformationNavComponent" }
}

