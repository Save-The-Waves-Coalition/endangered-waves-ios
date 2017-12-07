//
//  ImageSliderViewController.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/16/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit

protocol ImageSliderViewControllerDelegate: class {
    func viewController(_ viewController: ImageSliderViewController, didTapImage image: UIImage, atIndex index: Int)
}

class ImageSliderViewController: UIPageViewController {

    weak var imageSliderViewControllerDelegate: ImageSliderViewControllerDelegate?

    var images: [UIImage]? {
        didSet {
            if let images = self.images {
                let imageViewControllers = imageViewControllersForImages(images)
                currentPageIndex = 0
                nextPageIndex = 0
                self.imageViewControllers = imageViewControllers
                setViewControllers([imageViewControllers.first!], direction: .forward, animated: false, completion: nil)
            }
        }
    }

    private var imageViewControllers: [ImageViewController]?
    private var currentPageIndex = 0
    private var nextPageIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageSliderViewControllerWasTapped(sender:)))
        view.addGestureRecognizer(tapGestureRecognizer)

        dataSource = self
        delegate = self
    }

    @objc func imageSliderViewControllerWasTapped(sender: UITapGestureRecognizer) {
        if let images = self.images {
            let image = images[currentPageIndex]
            imageSliderViewControllerDelegate?.viewController(self, didTapImage: image, atIndex: currentPageIndex)
        }
    }

    func imageViewControllersForImages(_ images: [UIImage]) -> [ImageViewController] {

        let imageViewControllers: [ImageViewController] = images.map({
            (image: UIImage) -> ImageViewController in
            let imageViewController = ImageViewController.instantiate()
            imageViewController.image = image
            return imageViewController
        })

        return imageViewControllers
    }

    // Pull UIPageControl to the front and put it on top of the images
    // Sometimes I feel dirty:
    // https://stackoverflow.com/questions/21045630/how-to-put-the-uipagecontrol-element-on-top-of-the-sliding-pages-within-a-uipage
    // This is a hack that will break eventually, mark my words.
    override func viewDidLayoutSubviews() {
        for subView in self.view.subviews {
            if subView is UIScrollView {
                subView.frame = self.view.bounds
            } else if subView is UIPageControl {
                self.view.bringSubview(toFront: subView)

                if let imageControllers = self.imageViewControllers, imageControllers.count > 1 {
                    subView.isHidden = false
                } else {
                    subView.isHidden = true // If there is only 1 image don't show the dots
                }
            }
        }
        super.viewDidLayoutSubviews()
    }
}

// MARK: UIPageViewControllerDelegate
extension ImageSliderViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard finished else { return }
        currentPageIndex = nextPageIndex
    }

    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let viewController = pendingViewControllers.first as? ImageViewController,
            let imageViewControllers = self.imageViewControllers,
            let index = imageViewControllers.index(of: viewController) {
            nextPageIndex = index
        }
    }
}

// MARK: UIPageViewControllerDataSource
extension ImageSliderViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? ImageViewController,
            let imageViewControllers = self.imageViewControllers,
            let index = imageViewControllers.index(of: viewController),
            index > 0 else {
                return nil
        }

        return imageViewControllers[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let imageControllers = imageViewControllers,
            let viewController = viewController as? ImageViewController,
            let index = imageControllers.index(of: viewController),
            index < (imageControllers.count - 1) else {
            return nil
        }

        return imageControllers[index + 1]
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        guard let imageViewControllers = self.imageViewControllers else {
            return 0
        }

        let count = imageViewControllers.count
        if count > 1 {
            return count
        }
        return 1
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentPageIndex
    }
}
