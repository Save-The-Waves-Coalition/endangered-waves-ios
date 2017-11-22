//
//  ImageSliderViewController.swift
//  Endangered Waves
//
//  Created by Matthew Morey on 11/16/17.
//  Copyright © 2017 Save The Waves. All rights reserved.
//

import UIKit

protocol ImageSliderViewControllerDelegate: class {
    func viewController(_ viewController: ImageSliderViewController, didTapImageAtIndex index:Int)
}

class ImageSliderViewController: UIPageViewController {

    weak var imageSliderViewControllerDelegate: ImageSliderViewControllerDelegate?

    var images: [UIImage]? {
        didSet {
            if let images = self.images {
                self.imageViewControllers = imageViewControllersForImages(images)
                currentPageIndex = 0
                nextPageIndex = 0
                setViewControllers([imageViewControllers.first!], direction: .forward, animated: false, completion: nil)
            }
        }
    }

    private var imageViewControllers: [ImageViewController]!
    private var currentPageIndex = 0
    private var nextPageIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageSliderViewControllerWasTapped(sender:)))
        view.addGestureRecognizer(tapGestureRecognizer)

        dataSource = self
        delegate = self
    }

    @objc func imageSliderViewControllerWasTapped(sender:UITapGestureRecognizer) {
        imageSliderViewControllerDelegate?.viewController(self, didTapImageAtIndex: currentPageIndex)
    }

    func imageViewControllersForImages(_ images:[UIImage]) -> [ImageViewController] {

        let imageViewControllers: [ImageViewController] = images.map( {
            (image: UIImage) -> ImageViewController in
            let imageViewController = ImageViewController.instantiate()
            imageViewController.image = image
            return imageViewController
        })

        return imageViewControllers
    }

    // Pull UIPageControl to the front and put it on top of the images
    // Sometimes I feel dirty: https://stackoverflow.com/questions/21045630/how-to-put-the-uipagecontrol-element-on-top-of-the-sliding-pages-within-a-uipage
    // This is a hack that will break eventually, mark my words.
    override func viewDidLayoutSubviews() {
        for subView in self.view.subviews {
            if subView is UIScrollView {
                subView.frame = self.view.bounds
            } else if subView is UIPageControl {
                self.view.bringSubview(toFront: subView)
                if imageViewControllers.count < 2 {
                    subView.isHidden = true // If there is only 1 image don't show the dots
                } else {
                    subView.isHidden = false
                }
            }
        }
        super.viewDidLayoutSubviews()
    }
}

extension ImageSliderViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard finished else { return }
        currentPageIndex = nextPageIndex
    }

    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let viewController = pendingViewControllers.first as? ImageViewController, let index = imageViewControllers.index(of: viewController) {
            nextPageIndex = index
        }
    }
}

extension ImageSliderViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? ImageViewController,
            let index = imageViewControllers.index(of: viewController),
            index > 0 else {
                return nil
        }

        return imageViewControllers[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? ImageViewController,
            let index = imageViewControllers.index(of: viewController),
            index < (imageViewControllers.count - 1) else {
            return nil
        }

        return imageViewControllers[index + 1]
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
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
