//
//  ProductCell.swift
//  Product Catalogue
//
//  Copyright © 2016 Contentful GmbH. All rights reserved.
//

import ContentfulStyle
import UIKit

class ProductCell: UITableViewCell {
    lazy var pricingLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 70, height: 30))
        label.backgroundColor = UIColor(red: 216.0/255.0, green: 216.0/255.0, blue: 216.0/255.0, alpha: 1.0)
        label.font = UIFont.bodyTextFont()
        label.textAlignment = .Center
        label.textColor = UIColor.whiteColor()

        self.contentView.addSubview(label)

        return label
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = UIColor.whiteColor()
        separatorInset = UIEdgeInsetsZero
        textLabel?.font = UIFont.bodyTextFont()
        textLabel?.numberOfLines = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        imageView?.frame = CGRect(x: 10, y: 10, width: frame.size.height - 20, height: frame.size.height - 20)

        if let imageView = imageView, textLabel = textLabel {
            contentView.addSubview(imageView) // this should not be necessary

            var frame = pricingLabel.frame
            frame.origin.x = CGRectGetMaxX(imageView.frame) + 10
            frame.origin.y = CGRectGetMaxY(imageView.frame) - frame.size.height
            pricingLabel.frame = frame

            frame = textLabel.frame
            frame.origin.x = pricingLabel.frame.origin.x
            frame.origin.y = imageView.frame.origin.y + 20
            frame.size.width = self.frame.size.width - frame.origin.x - 20
            frame.size.height = pricingLabel.frame.origin.y - frame.origin.y - 10
            textLabel.frame = frame
        }

        textLabel?.sizeToFit()
    }
}

import CoreData

extension ProductCell : CellConfigurable {
    func configure(dataObject: NSManagedObject) {
        if let product = dataObject as? Product {
            if let image = product.image?.firstObject as? Asset {
                fetchAsset(image, for: imageView)
            }

            if let price = product.price {
                pricingLabel.text = "\(price) €"
            }

            textLabel?.text = product.productName
        }
    }
}
