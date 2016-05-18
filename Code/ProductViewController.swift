//
//  ProductViewController.swift
//  Product Catalogue
//
//  Copyright © 2016 Contentful GmbH. All rights reserved.
//

import ContentfulStyle
import UIKit

class ProductViewController: ScrollingViewController {
    @IBOutlet weak var availabilityLabel: UILabel!
    @IBOutlet weak var brandButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var byLabel: UILabel!
    @IBOutlet weak var pricingLabel: UILabel!
    @IBOutlet weak var productDescription: UITextView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var sizeTypeColorTitleLabel: UILabel!
    @IBOutlet weak var sizeTypeColorLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var tagsTitleLabel: UILabel!

    var product: Product?

    override var contentHeight: CGFloat {
        return 410 + self.productNameLabel.intrinsicContentSize().height + self.productDescription.intrinsicContentSize().height + self.sizeTypeColorLabel.intrinsicContentSize().height +  self.tagsLabel.intrinsicContentSize().height
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let galleryViewController = segue.destinationViewController as? GalleryViewController, images = product?.image  where segue.identifier == SegueIdentifier.EmbedGalleryVCSegue.rawValue {
            galleryViewController.assets = Array(images.array[0..<min(images.count ?? 0, 5)]).flatMap { $0 as? Asset }
        }

        if let brandDetailsViewController = segue.destinationViewController as? BrandDetailsViewController where segue.identifier == SegueIdentifier.ShowBrandDetailsSegue.rawValue {
            brandDetailsViewController.brand = product?.brand
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        productDescription.selectable = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)

        availabilityLabel.font = UIFont.bodyTextFont()
        availabilityLabel.textColor = UIColor.contentfulDeactivatedColor()
        brandButton.titleLabel?.font = UIFont.buttonTitleFont()
        buyButton.titleLabel?.font = UIFont.buttonTitleFont()
        byLabel.font = UIFont.buttonTitleFont()
        pricingLabel.font = UIFont.bodyTextFont()
        productDescription.font = UIFont.bodyTextFont()
        productNameLabel.font = UIFont.bodyTextFont()
        sizeTypeColorLabel.font = UIFont.bodyTextFont()
        sizeTypeColorTitleLabel.font = UIFont.bodyTextFont()
        tagsLabel.font = UIFont.bodyTextFont()
        tagsTitleLabel.font = UIFont.bodyTextFont()

        buyButton.backgroundColor = UIColor.contentfulPrimaryColor()
        buyButton.layer.cornerRadius = 4.0
        buyButton.tintColor = UIColor.whiteColor()

        brandButton.enabled = product?.brand != nil

        buyButton.addTarget(self, action: #selector(ProductViewController.buyButtonTapped), forControlEvents: .TouchUpInside)
        buyButton.enabled = product?.website?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0

        title = product?.productName

        let quantity = (product?.quantity?.integerValue ?? 0)
        if quantity == 0 {
            availabilityLabel.text = NSLocalizedString("No products\nin stock", comment: "Product quantity label")
        } else if quantity > 1 {
            let localizedString = NSLocalizedString("%d items in stock", comment: "Product quantity label")
            availabilityLabel.text = NSString(format: localizedString, quantity) as String
        }

        let localizedString = NSLocalizedString("by %@", comment: "Brand button")
        brandButton.setTitle(NSString(format: localizedString, product?.brand?.companyName ?? "") as String, forState: .Normal)
        pricingLabel.text = NSString(format: NSLocalizedString("%@ EUR", comment: "Pricing label"), product?.price ?? "0") as String
        productDescription.text = product?.productDescription
        productNameLabel.text = product?.productName
        sizeTypeColorLabel.text = product?.sizetypecolor

        if let tags = product?.tags {
            let tagsArray = NSKeyedUnarchiver.unarchiveObjectWithData(tags)
            tagsLabel.text = tagsArray?.componentsJoinedByString(", ")
        }
    }

    // MARK: - Actions

    func buyButtonTapped() {
        if let website = product?.website, url = NSURL(string: website) {
            showURL(url, on: self)
        }
    }
}
