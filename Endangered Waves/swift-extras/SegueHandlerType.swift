//
//  SegueHandlerType.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/11/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import Foundation
import UIKit

/* The SegueHandlerType pattern, as seen on [1, 2], adapted for the changed Swift 3 syntax.
 [1] https://developer.apple.com/library/content/samplecode/Lister/Listings/Lister_SegueHandlerType_swift.html
 [2] https://www.natashatherobot.com/protocol-oriented-segue-identifiers-swift/
 */

protocol SegueHandlerType {
    associatedtype SegueIdentifier: RawRepresentable
}

extension SegueHandlerType where Self: UIViewController, SegueIdentifier.RawValue == String {

    func performSegue(withIdentifier identifier: SegueIdentifier, sender: Any?) {
        performSegue(withIdentifier: identifier.rawValue, sender: sender)
    }

    func segueIdentifier(for segue: UIStoryboardSegue) -> SegueIdentifier {
        guard let identifier = segue.identifier, let segueIdentifier = SegueIdentifier(rawValue: identifier) else {
            fatalError("Couldn't handle segue identifier \(String(describing: segue.identifier)) for view controller of type \(type(of: self)).")
        }
        return segueIdentifier
    }
}
