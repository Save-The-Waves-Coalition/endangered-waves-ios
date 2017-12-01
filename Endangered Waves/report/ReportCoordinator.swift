//
//  ReportCoordinator.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/25/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit
import Lightbox

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
        let vc = ReportDetailViewController.instantiate()
        vc.delegate = self
        vc.report = report
        navVC.pushViewController(vc, animated: true)
    }

    override func stop() {
        delegate?.coordinatorDidFinishViewingReport(self)
    }

    func showLightboxComponentWithImages(_ images: [UIImage], atIndex index: Int) {
        if let vc = lightboxForImages(images, withStartIndex: index) {
            rootViewController.present(vc, animated: true, completion: nil)
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
}