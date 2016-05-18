//
//  BrandDetailsViewController.swift
//  Product Catalogue
//
//  Copyright © 2016 Contentful GmbH. All rights reserved.
//

import ContentfulStyle
import DZNWebViewController
import UIKit

func showURL(url: NSURL, on viewController: UIViewController) {
    let browser = DZNWebViewController(URL: url)
    browser.supportedWebActions = .DZNWebActionNone
    browser.supportedWebNavigationTools = .None
    viewController.navigationController?.pushViewController(browser, animated: true)
}

class BrandDetailsViewController: ScrollingViewController {
    @IBOutlet weak var brandDescription: UITextView!
    @IBOutlet weak var brandLogoView: UIImageView!
    @IBOutlet weak var brandWebsiteButton: UIButton!

    var brand: Brand?

    override var contentHeight: CGFloat {
        return 200 + brandDescription.intrinsicContentSize().height
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        brandDescription.selectable = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)

        brandDescription?.font = UIFont.bodyTextFont()
        brandWebsiteButton?.titleLabel?.font = UIFont.buttonTitleFont()

        brandLogoView?.image = UIImage(named: "placeholder")
        if let logo = brand?.logo {
            // TODO: Should only fetch a 100x100 version of the asset
            fetchAsset(logo, for: brandLogoView)
        }

        brandDescription?.text = brand?.companyDescription
        title = brand?.companyName

        brandWebsiteButton.addTarget(self, action: #selector(BrandDetailsViewController.websiteButtonTapped), forControlEvents: .TouchUpInside)
        brandWebsiteButton.hidden = brand?.website?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0
    }

    // MARK: - Actions

    func websiteButtonTapped() {
        if let website = brand?.website, url = NSURL(string: website) {
            showURL(url, on: self)
        }
    }
}
