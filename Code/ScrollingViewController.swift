//
//  ScrollingViewController.swift
//  Product Catalogue
//
//  Copyright © 2016 Contentful GmbH. All rights reserved.
//

import UIKit

class ScrollingViewController: UIViewController {
    var contentHeight: CGFloat {
        return self.view.frame.size.height
    }

    override func loadView() {
        super.loadView()

        let scrollView = UIScrollView(frame: view.frame)
        scrollView.backgroundColor = UIColor.whiteColor()
        scrollView.addSubview(view)

        self.view = scrollView
    }

    func updateContentSize(to height: CGFloat) {
        if let contentView = view.subviews.first {
            contentView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: height)

            if let scrollView = view as? UIScrollView {
                scrollView.contentSize = contentView.frame.size
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        updateContentSize(to: contentHeight)
        view.layoutIfNeeded()
    }
}
