//
//  ProductCategoryCell.swift
//  Product Catalogue
//
//  Created by Boris Bügling on 13/05/16.
//  Copyright © 2016 Contentful GmbH. All rights reserved.
//

import ContentfulStyle
import UIKit

let TextLabelHeight = CGFloat(30)

class ProductCategoryCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)

        accessoryType = .DisclosureIndicator

        detailTextLabel?.font = UIFont.tabTitleFont()
        detailTextLabel?.textColor = UIColor.contentfulDeactivatedColor()

        textLabel?.font = UIFont.bodyTextFont()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if var frame = textLabel?.frame {
            frame.origin.y += frame.size.height - TextLabelHeight
            frame.size.height = TextLabelHeight
            textLabel?.frame = frame
        }
    }
}

import CoreData

extension ProductCategoryCell : CellConfigurable {
    func configure(dataObject: NSManagedObject) {
        if let category = dataObject as? ProductCategory {
            textLabel?.text = category.title

            let localizedString = NSLocalizedString("%d products", comment: "Number of products label")
            detailTextLabel?.text = NSString(format: localizedString, category.categoriesInverse?.count ?? 0) as String
        }
    }
}
