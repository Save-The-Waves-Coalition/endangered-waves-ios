//
//  OnboardingViewController.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/14/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit

protocol OnboardingViewControllerDelegate: class {
    func controller(_ controller: OnboardingViewController, didTapSkipButton button: UIButton?)
}

class OnboardingViewController: UIViewController {
    weak var onboardingDelegate: OnboardingViewControllerDelegate?

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var skipButton: UIButton!

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        return scrollView
    }()

    private var controllers = [UIViewController]()

    var currentPage: Int {
        let page = Int((scrollView.contentOffset.x / view.bounds.size.width))
        return page
    }

    var numberOfPages: Int {
        return self.controllers.count
    }

    private var lastViewContraints: [NSLayoutConstraint]?

    // View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        pageControl.addTarget(self, action: #selector(pageControllerWasTouched), for: .touchUpInside)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(scrollView, belowSubview: pageControl)

        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[scrollview]-0-|",
                                                           options: [],
                                                           metrics: nil,
                                                           views: ["scrollview": scrollView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[scrollview]-0-|",
                                                           options: [],
                                                           metrics: nil,
                                                           views: ["scrollview": scrollView]))

        addViewController(OnboardingPageOneViewController.instantiate())
        addViewController(OnboardingPageTwoViewController.instantiate())
        addViewController(OnboardingPageThreeViewController.instantiate())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        pageControl.numberOfPages = self.numberOfPages
        pageControl.currentPage = 0
    }

    // Actions

    @IBAction func skipButtonWasTapped(_ sender: UIButton) {
        onboardingDelegate?.controller(self, didTapSkipButton: sender)
    }

    // Helpers

    func addViewController(_ viewController: UIViewController) {
        // Add view controller
        controllers.append(viewController)
        addChild(viewController)

        // Add view
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(viewController.view)

        let metrics = ["w": viewController.view.bounds.size.width, "h": viewController.view.bounds.size.height]
        viewController.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[view(h)]",
                                                                          options: [],
                                                                          metrics: metrics,
                                                                          views: ["view": viewController.view!]))
        viewController.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[view(w)]",
                                                                          options: [],
                                                                          metrics: metrics,
                                                                          views: ["view": viewController.view!]))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]|",
                                                                 options: [],
                                                                 metrics: nil,
                                                                 views: ["view": viewController.view!]))

        if self.numberOfPages == 1 {
            scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]",
                                                                     options: [],
                                                                     metrics: nil,
                                                                     views: ["view": viewController.view!]))
        } else {
            let previousVC = controllers[self.numberOfPages - 2]
            let previousView = previousVC.view!

            scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[previousView]-0-[view]",
                                                                     options: [],
                                                                     metrics: nil,
                                                                     views: ["previousView": previousView, "view": viewController.view!]))

            if let constraints = lastViewContraints {
                scrollView.removeConstraints(constraints)
            }
            lastViewContraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[view]-0-|",
                                                                options: [],
                                                                metrics: nil,
                                                                views: ["view": viewController.view!])
            if let lastViewConstraints = lastViewContraints {
                scrollView.addConstraints(lastViewConstraints)
            }
        }

        // Finish up
        viewController.didMove(toParent: self)
    }

    @objc func pageControllerWasTouched() {
        navigateToPage(page: pageControl.currentPage)
    }

    private func navigateToPage(page: Int) {
        if page < self.numberOfPages {
            var frame = scrollView.frame
            frame.origin.x = CGFloat(page) * frame.size.width
            scrollView.scrollRectToVisible(frame, animated: true)
        }
    }

    private func updateSkipText() {
        if currentPage == numberOfPages - 1 {
            skipButton.setTitle("GET STARTED!".localized(), for: .normal)
        } else {
            skipButton.setTitle("SKIP".localized(), for: .normal)
        }
    }
}

// MARK: UIScrollViewDelegate
extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = currentPage
        updateSkipText()
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pageControl.currentPage = currentPage
        updateSkipText()
    }
}

// MARK: 📖 StoryboardInstantiable
extension OnboardingViewController: StoryboardInstantiable {
    static var storyboardName: String { return "onboarding" }
    static var storyboardIdentifier: String? { return "OnboardingPageComponent" }
}

class OnboardingPageOneViewController: UIViewController {

}
// MARK: 📖 StoryboardInstantiable
extension OnboardingPageOneViewController: StoryboardInstantiable {
    static var storyboardName: String { return "onboarding" }
    static var storyboardIdentifier: String? { return "OnboardingPageOneComponent" }
}

class OnboardingPageTwoViewController: UIViewController {

}
// MARK: 📖 StoryboardInstantiable
extension OnboardingPageTwoViewController: StoryboardInstantiable {
    static var storyboardName: String { return "onboarding" }
    static var storyboardIdentifier: String? { return "OnboardingPageTwoComponent" }
}

class OnboardingPageThreeViewController: UIViewController {

}
// MARK: 📖 StoryboardInstantiable
extension OnboardingPageThreeViewController: StoryboardInstantiable {
    static var storyboardName: String { return "onboarding" }
    static var storyboardIdentifier: String? { return "OnboardingPageThreeComponent" }
}
