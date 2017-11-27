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

class OnboardingViewController: UIPageViewController {

    weak var onboardingDelegate: OnboardingViewControllerDelegate?

    var pagedViewControllers: [UIViewController] = [OnboardingPageOneViewController.instantiate(),
                                                    OnboardingPageTwoViewController.instantiate(),
                                                    OnboardingPageThreeViewController.instantiate(),
                                                    OnboardingPageFourViewController.instantiate()]

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.dataSource = self // Uncomment to enable user interactions
        self.setViewControllers([pagedViewControllers[0]], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.advanceToIndex1), userInfo: nil, repeats: false)
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.advanceToIndex2), userInfo: nil, repeats: false)
        Timer.scheduledTimer(timeInterval: 8, target: self, selector: #selector(self.advanceToIndex3), userInfo: nil, repeats: false)
        Timer.scheduledTimer(timeInterval: 11, target: self, selector: #selector(self.fadeAway), userInfo: nil, repeats: false)
    }

    @objc func advanceToIndex1() {
        self.setViewControllers([pagedViewControllers[1]], direction: .forward, animated: true, completion: nil)
    }

    @objc func advanceToIndex2() {
        self.setViewControllers([pagedViewControllers[2]], direction: .forward, animated: true, completion: nil)
    }

    @objc func advanceToIndex3() {
        self.setViewControllers([pagedViewControllers[3]], direction: .forward, animated: true, completion: nil)
    }

    @objc func fadeAway() {
        UIView.animate(withDuration: 0.5, animations: {
            self.view.alpha = 0
        }) { (finished) in
            self.onboardingDelegate?.controller(self, didTapSkipButton: nil)
        }
    }

    @IBAction func skipButtonWasTapped(_ sender: UIButton) {
        onboardingDelegate?.controller(self, didTapSkipButton: sender)
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController is OnboardingPageOneViewController {
            return nil
        } else if viewController is OnboardingPageTwoViewController {
            return pagedViewControllers[0]
        } else if viewController is OnboardingPageThreeViewController {
            return pagedViewControllers[1]
        } else if viewController is OnboardingPageFourViewController {
            return pagedViewControllers[2]
        }

        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController is OnboardingPageOneViewController {
            return pagedViewControllers[1]
        } else if viewController is OnboardingPageTwoViewController {
            return pagedViewControllers[2]
        } else if viewController is OnboardingPageThreeViewController {
            return pagedViewControllers[3]
        } else if viewController is OnboardingPageFourViewController {
            return nil
        }

        return nil
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

class OnboardingPageFourViewController: UIViewController {

}
// MARK: 📖 StoryboardInstantiable
extension OnboardingPageFourViewController: StoryboardInstantiable {
    static var storyboardName: String { return "onboarding" }
    static var storyboardIdentifier: String? { return "OnboardingPageFourComponent" }
}
