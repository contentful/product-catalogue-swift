//
//  GalleryViewController.swift
//  Product Catalogue
//
//  Copyright © 2016 Contentful GmbH. All rights reserved.
//

import Masonry
import UIKit

class GalleryViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    var assets = [Asset]()

    lazy var leftButton: UIButton = {
        let leftButton = self.buildButtonUsingAdditionalConstraints {
            $0.left.equalTo()(0)
        }

        leftButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))

        leftButton.addTarget(self, action: #selector(GalleryViewController.scrollLeft(_:)), forControlEvents: .TouchUpInside)
        return leftButton
    }()

    lazy var rightButton: UIButton = {
        let rightButton = self.buildButtonUsingAdditionalConstraints {
            $0.right.equalTo()(0)
        }

        rightButton.addTarget(self, action: #selector(GalleryViewController.scrollRight(_:)), forControlEvents: .TouchUpInside)
        return rightButton
    }()

    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = pageControl.tintColor
        pageControl.numberOfPages = self.assets.count
        pageControl.pageIndicatorTintColor = UIColor.lightGrayColor()
        self.view.addSubview(pageControl)

        pageControl.mas_makeConstraints { make in
            make?.centerX.equalTo()(self.view.mas_centerX)
            make?.bottom.equalTo()(5)
            make?.width.equalTo()(40)
            make?.height.equalTo()(40)
        }

        return pageControl
    }()

    func buildButtonUsingAdditionalConstraints(block: ((make: MASConstraintMaker) -> ())?) -> UIButton {
        let button = UIButton(type: .Custom)
        button.enabled = false
        button.setImage(UIImage(named: "right-arrow"), forState: .Normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 13, left: 10, bottom: 14, right: 10)
        view.addSubview(button)

        button.mas_makeConstraints { make in
            make?.width.equalTo()(31)
            make?.height.equalTo()(44)
            make?.centerY.equalTo()(self.view.mas_centerY)

            if let block = block, make = make {
                block(make: make)
            }
        }

        return button
    }

    func imageViewController(at index: Int) -> ImageViewController? {
        if index < 0 || index >= assets.count {
            return nil
        }

        let imageViewController = ImageViewController()
        imageViewController.asset = assets[index]
        imageViewController.padding = UIEdgeInsets(top: 10, left: 36, bottom: 45, right: 36)
        return imageViewController
    }

    func indexOf(viewController: UIViewController) -> Int {
        let imageViewController = viewController as! ImageViewController
        return assets.indexOf(imageViewController.asset!)!
    }

    required init?(coder: NSCoder) {
        super.init(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        dataSource = self
        delegate = self
    }

    func updateCurrentIndex(currentIndex: Int) {
        pageControl.currentPage = currentIndex

        leftButton.enabled = currentIndex > 0
        leftButton.alpha = leftButton.enabled ? 1.0 : 0.5

        rightButton.enabled = currentIndex < assets.count - 1
        rightButton.alpha = rightButton.enabled ? 1.0 : 0.5
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if let imageViewController = self.imageViewController(at: 0) {
            setViewControllers([ imageViewController ], direction: .Forward, animated: false) {
                if $0 {
                    self.updateCurrentIndex(0)
                }
            }
        }
    }

    // MARK: - Actions

    func scrollToViewController(viewController: UIViewController, direction: UIPageViewControllerNavigationDirection) {
        setViewControllers([ viewController ], direction: direction, animated: true) { _ in
            let currentIndex = self.indexOf(viewController)
            self.updateCurrentIndex(currentIndex)
        }
    }

    func scrollLeft(button: UIButton) {
        if let viewController = viewControllers?.first, next = pageViewController(self, viewControllerBeforeViewController: viewController) {
            scrollToViewController(next, direction: .Reverse)
        }
    }

    func scrollRight(button: UIButton) {
        if let viewController = viewControllers?.first, next = pageViewController(self, viewControllerAfterViewController: viewController) {
            scrollToViewController(next, direction: .Forward)
        }
    }

    // MARK: - UIPageViewControllerDataSource

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let currentIndex = self.indexOf(viewController)
        return imageViewController(at: currentIndex + 1)
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let currentIndex = self.indexOf(viewController)
        return imageViewController(at: currentIndex - 1)
    }

    // MARK: - UIPageViewControllerDelegate

    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let viewController = viewControllers?.first where completed {
            let currentIndex = indexOf(viewController)
            updateCurrentIndex(currentIndex)
        }
    }
}
