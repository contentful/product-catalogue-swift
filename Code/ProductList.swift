//
//  ProductList.swift
//  Product Catalogue
//
//  Copyright © 2016 Contentful GmbH. All rights reserved.
//

import UIKit

class ProductList: UITableViewController {
    lazy var dataManager: ContentfulDataManager = {
        return ContentfulDataManager()
    }()

    lazy var dataSource: CoreDataFetchDataSource<ProductCell> = {
        let resultsController = try! self.dataManager.fetchedResultsController(forContentType: Product.self, predicate: self.predicate, sortDescriptors: [NSSortDescriptor(key: "productName", ascending: true)])
        return CoreDataFetchDataSource<ProductCell>(fetchedResultsController: resultsController, tableView: self.tableView)
    }()

    var predicate: NSPredicate = NSPredicate(value: true)

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidBecomeActiveNotification, object: nil)
    }

    func refresh() {
        tabBarController?.view.userInteractionEnabled = false

        let refresh = {
            try self.dataSource.performFetch()

            self.tabBarController?.view.userInteractionEnabled = true

            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProductList.refresh), name: UIApplicationDidBecomeActiveNotification, object: nil)
        }

        dataManager.performSynchronization { result in
            // FIXME: Show synchronization errors somehow unless `NSURLErrorNotConnectedToInternet`
            dispatch_async(dispatch_get_main_queue()) {
                if result {
                    do {
                        try refresh()
                    } catch {}
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = dataSource
        tableView.rowHeight = 130
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .Plain, target: nil, action: nil)

        tableView.registerClass(ProductCell.self, forCellReuseIdentifier: ProductCell.cellIdentifier)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        refresh()
    }

    // MARK: - UITableViewDelegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let detail = storyboard?.instantiateViewControllerWithIdentifier(ViewControllerStoryboardIdentifier.ProductViewControllerSegue.rawValue) as? ProductViewController {
            detail.product = (dataSource.fetchedResultsController.objectAtIndexPath(indexPath) as! Product)
            navigationController?.pushViewController(detail, animated: true)
        }
    }
}
