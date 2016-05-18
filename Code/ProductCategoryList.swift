//
//  ProductCategoryList.swift
//  Product Catalogue
//
//  Copyright © 2016 Contentful GmbH. All rights reserved.
//

import UIKit

class ProductCategoryList: UITableViewController {
    lazy var dataManager: ContentfulDataManager = {
        return ContentfulDataManager()
    }()

    lazy var dataSource: CoreDataFetchDataSource<ProductCategoryCell> = {
        let resultsController = try! self.dataManager.fetchedResultsController(forContentType: ProductCategory.self, predicate: NSPredicate(value: true), sortDescriptors: [NSSortDescriptor(key: "title", ascending: true)])
        return CoreDataFetchDataSource<ProductCategoryCell>(fetchedResultsController: resultsController, tableView: self.tableView)
    }()

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
        tableView.rowHeight = 70
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .Plain, target: nil, action: nil)

        tableView.registerClass(ProductCategoryCell.self, forCellReuseIdentifier: ProductCategoryCell.cellIdentifier)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        refresh()
    }

    // MARK: - UITableViewDelegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let category = dataSource.fetchedResultsController.objectAtIndexPath(indexPath) as? ProductCategory, filteredProductList = storyboard?.instantiateViewControllerWithIdentifier(TableViewControllerStoryboardIdentifier.FilteredProductsViewControllerSegue.rawValue) as? ProductList {
            filteredProductList.predicate = NSPredicate(format: "ANY categories.identifier == '%@'", category.identifier!)
            filteredProductList.title = category.title
            navigationController?.pushViewController(filteredProductList, animated: true)
        }
    }
    
}
