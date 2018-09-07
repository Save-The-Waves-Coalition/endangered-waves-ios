//
//  CompetitionViewController.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 9/6/18.
//  Copyright © 2018 Save The Waves. All rights reserved.
//

import UIKit

protocol CompetitionViewControllerDelegate: class {
    func controller(_ controller: CompetitionViewController, didTapCloseButton button: UIButton?)
}

class CompetitionViewController: UIViewController {

    weak var competitionDelegate: CompetitionViewControllerDelegate?

}

// MARK: 📖 StoryboardInstantiable
extension CompetitionViewController: StoryboardInstantiable {
    static var storyboardName: String { return "competition" }
    static var storyboardIdentifier: String? { return "CompetitionPageComponent" }
}

// MARK: UIViewControllerTransitioningDelegate
extension CompetitionViewController: UIViewControllerTransitioningDelegate {

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }

}

// MARK: UIPresentationController
class HalfSizePresentationController: UIPresentationController {
    var touchForwardingView: PSPDFTouchForwardingView!

    override var frameOfPresentedViewInContainerView: CGRect {

        guard let theView = containerView else {
            return CGRect.zero
        }

        let height =  theView.bounds.height * 0.6
        let width = theView.bounds.width * 0.9
        let xCord = (theView.bounds.width - width) / 2
        let yCord = (theView.bounds.height - height) / 2

        return CGRect(x: xCord, y: yCord, width: width, height: height)
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        touchForwardingView = PSPDFTouchForwardingView(frame: containerView!.bounds)
        touchForwardingView.passthroughViews = [presentingViewController.view]
        containerView?.insertSubview(touchForwardingView, at: 0)
    }
}
