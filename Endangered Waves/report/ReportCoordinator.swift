//
//  ReportCoordinator.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/25/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit

protocol ReportCoordinatorDelegate: class {
    func coordinatorDidFinishViewingReport(_ coordinator: ReportCoordinator)
}

class ReportCoordinator: Coordinator {

    weak var delegate: ReportCoordinatorDelegate?

    var report: Report!

    init(with rootViewController: UIViewController, report: Report) {
        super.init(with: rootViewController)
        self.report = report
    }

    override func start() {
        guard let navVC = rootViewController as? NavigationViewController else {
            return
        }
        let viewController = ReportDetailViewController.instantiate()
        viewController.delegate = self
        viewController.report = report
        navVC.pushViewController(viewController, animated: true)
    }

    override func stop() {
        delegate?.coordinatorDidFinishViewingReport(self)
    }

    func showLightboxComponentWithImages(_ images: [UIImage], atIndex index: Int) {
        if let viewController = lightboxWithNavigationViewControllerForImages(images, withStartIndex: index) {
            rootViewController.present(viewController, animated: true, completion: nil)
        }
    }
}

extension ReportCoordinator: ReportDetailViewControllerDelegate {
    func viewController(_ viewController: ReportDetailViewController, didTapImages images: [UIImage], atIndex index: Int) {
        showLightboxComponentWithImages(images, atIndex: index)
    }

    func finishedViewingDetailsViewController(_ viewController: ReportDetailViewController) {
        stop()
    }

    func showMapDetail() {
        guard let navVC = rootViewController as? NavigationViewController else {
            return
        }

        let mapVC = ReportDetailMapViewController.instantiate()
        mapVC.report = report
//        navVC.show(mapVC, sender: self)
        navVC.pushViewController(mapVC, animated: true)
    }
}

extension ReportCoordinator {
    func lightboxForImages(_ images: [UIImage], withStartIndex index: Int) -> LightboxController? {
        guard images.count > 0 else { return nil }

        let lightboxImages = images.map {
            return LightboxImage(image: $0)
        }

        let lightbox = LightboxController(images: lightboxImages, startIndex: index)
        return lightbox
    }

    func lightboxWithNavigationViewControllerForImages(_ images: [UIImage], withStartIndex index: Int) -> UINavigationController? {
        if let lightbox = lightboxForImages(images, withStartIndex: index) {
            let navigationViewController = NavigationViewController(rootViewController: lightbox)
            navigationViewController.isNavigationBarHidden = true
            navigationViewController.modalPresentationStyle = .fullScreen
            lightbox.dynamicBackground = true
            return navigationViewController
        }
        return nil
    }
}
