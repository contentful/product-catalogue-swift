//
//  ImageViewController.swift
//  Product Catalogue
//
//  Copyright © 2016 Contentful GmbH. All rights reserved.
//

import Masonry
import UIKit

func fetchAsset(asset: Asset, completion: (UIImage) -> ()) {
    guard let urlString = asset.url, url = NSURL(string: urlString) else { return }

    let task = NSURLSession.sharedSession().dataTaskWithURL(url) { data, _, _ in
        if let data = data, image = UIImage(data: data) {
            completion(image)
        }
    }

    task.resume()
}

func fetchAsset(asset: Asset, for imageView: UIImageView?) {
    fetchAsset(asset) { image in
        dispatch_async(dispatch_get_main_queue()) {
            imageView?.image = image
            imageView?.contentMode = .ScaleAspectFit
        }
    }
}

class ImageViewController: UIViewController {
    var asset: Asset?
    var padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        let imageView = UIImageView()
        fetchAsset(asset!, for: imageView)
        view.addSubview(imageView)

        imageView.mas_makeConstraints { make in
            make?.edges.equalTo()(self.view).with().insets()(self.padding)
        }
    }
}
