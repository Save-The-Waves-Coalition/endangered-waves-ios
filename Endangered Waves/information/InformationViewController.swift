//
//  InformationViewController.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/21/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit

protocol InformationViewControllerDelegate: class {
    func viewController(_ viewController: InformationViewController, didTapDoneButton button: UIBarButtonItem)
}

class InformationViewController: UITableViewController {

    weak var delegate: InformationViewControllerDelegate?

    @IBAction func didTapDoneButton(_ sender: UIBarButtonItem) {
        delegate?.viewController(self, didTapDoneButton: sender)
    }
}

extension InformationViewController: StoryboardInstantiable {
    static var storyboardName: String { return "information" }
    static var storyboardIdentifier: String? { return "InformationComponent" }
}
