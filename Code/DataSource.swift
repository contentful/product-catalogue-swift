//
//  DataSource.swift
//  Product Catalogue
//
//  Copyright © 2016 Contentful GmbH. All rights reserved.
//

import CoreData
import UIKit

protocol CellConfigurable : CellIdentifiable {
    func configure(dataObject: NSManagedObject)
}

protocol CellIdentifiable {
    static var cellIdentifier: String { get }
}

extension UICollectionViewCell : CellIdentifiable {
    @nonobjc static let cellIdentifier = String(self)
}

extension UITableViewCell : CellIdentifiable {
    @nonobjc static let cellIdentifier = String(self)
}

// MARK: -

class CoreDataFetchDataSource<T: CellConfigurable>: NSObject, NSFetchedResultsControllerDelegate, UICollectionViewDataSource, UITableViewDataSource {
    let collectionView: UICollectionView?
    let fetchedResultsController: NSFetchedResultsController
    let tableView: UITableView?

    var objectChanges = [[NSFetchedResultsChangeType:[NSIndexPath]]]()
    var sectionChanges = [[NSFetchedResultsChangeType:Int]]()

    init(fetchedResultsController: NSFetchedResultsController, collectionView: UICollectionView) {
        self.fetchedResultsController = fetchedResultsController
        self.collectionView = collectionView
        self.tableView = nil

        super.init()

        self.fetchedResultsController.delegate = self
    }

    init(fetchedResultsController: NSFetchedResultsController, tableView: UITableView) {
        self.fetchedResultsController = fetchedResultsController
        self.collectionView = nil
        self.tableView = tableView

        super.init()

        self.fetchedResultsController.delegate = self
    }

    func performFetch() throws {
        try fetchedResultsController.performFetch()

        collectionView?.reloadData()
        tableView?.reloadData()
    }

    // MARK: - NSFetchedResultsControllerDelegate

    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        objectChanges.removeAll()
        sectionChanges.removeAll()

        tableView?.beginUpdates()
    }


    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        var change = [NSFetchedResultsChangeType:[NSIndexPath]]()

        switch type {

        case .Insert:
            if let newIndexPath = newIndexPath {
                change[type] = [newIndexPath]

                tableView?.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Automatic)
            }

        case .Delete:
            if let indexPath = indexPath {
                change[type] = [indexPath]

                tableView?.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }

        case .Update:
            if let indexPath = indexPath {
                change[type] = [indexPath]

                let dataObject = fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject

                if let cell = collectionView?.cellForItemAtIndexPath(indexPath) {
                    (cell as! CellConfigurable).configure(dataObject)
                }

                if let cell = tableView?.cellForRowAtIndexPath(indexPath) {
                    (cell as! CellConfigurable).configure(dataObject)
                }
            }

        case .Move:
            if let indexPath = indexPath, newIndexPath = newIndexPath {
                change[type] = [indexPath, newIndexPath]

                tableView?.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                tableView?.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Automatic)
            }
        }

        objectChanges.append(change)
    }

    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        var change = [NSFetchedResultsChangeType:Int]()

        switch type {

        case .Insert:
            change[type] = sectionIndex

            tableView?.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)

        case .Delete:
            change[type] = sectionIndex

            tableView?.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)

        default:
            break
        }

        sectionChanges.append(change)
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        collectionView?.performBatchUpdates({
            self.sectionChanges.forEach {
                $0.forEach {
                    let set = NSIndexSet(index: $0.1)

                    switch $0.0 {
                    case .Insert:
                        self.collectionView?.insertSections(set)

                    case .Delete:
                        self.collectionView?.deleteSections(set)

                    default:
                        break
                    }
                }
            }

            self.objectChanges.forEach {
                $0.forEach {
                    switch $0.0 {
                    case .Insert:
                        self.collectionView?.insertItemsAtIndexPaths($0.1)

                    case .Delete:
                        self.collectionView?.deleteItemsAtIndexPaths($0.1)

                    case .Update:
                        if let section = $0.1.first?.section {
                            self.collectionView?.reloadSections(NSIndexSet(index: section))
                        }

                    case .Move:
                        self.collectionView?.deleteItemsAtIndexPaths([ $0.1[0] ])
                        self.collectionView?.insertItemsAtIndexPaths([ $0.1[1] ])
                    }
                }
            }
        }, completion: { _ in
            self.sectionChanges.removeAll()
            self.objectChanges.removeAll()
        })

        var sectionWasReloaded = [Bool](count: fetchedResultsController.sections?.count ?? 0, repeatedValue: false)

        objectChanges.forEach {
            $0.forEach {
                guard let section = $0.1.first?.section else { return }

                switch $0.0 {
                case .Update:
                    if !sectionWasReloaded[section] {
                        tableView?.reloadSections(NSIndexSet(index: section), withRowAnimation: .Automatic)
                        sectionWasReloaded[section] = true
                    }

                default:
                    break
                }
            }
        }

        tableView?.endUpdates()
    }

    // MARK: - UICollectionViewDataSource

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections?[section]
        return sectionInfo?.numberOfObjects ?? 0
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(T.cellIdentifier, forIndexPath: indexPath)
        let dataObject = fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
        (cell as! CellConfigurable).configure(dataObject)
        return cell
    }

    // MARK: - UITableViewDataSource

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections?[section]
        return sectionInfo?.numberOfObjects ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(T.cellIdentifier, forIndexPath: indexPath)
        let dataObject = fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
        (cell as! CellConfigurable).configure(dataObject)
        return cell
    }
}
