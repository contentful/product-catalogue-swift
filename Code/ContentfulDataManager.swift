//
//  ContentfulDataManager.swift
//  Product Catalogue
//
//  Copyright © 2016 Contentful GmbH. All rights reserved.
//

import CoreData
import Contentful
import ContentfulPersistence
import Interstellar
import Keys

let BrandContentTypeId = "brand"
let CategoryContentTypeId = "category"
let ProductContentTypeId = "product"

class ContentfulDataManager {
    let storeURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last?.URLByAppendingPathComponent("Product Catalogue")

    lazy var managedObjectContext: NSManagedObjectContext = {
        let modelURL = NSBundle(forClass: self.dynamicType).URLForResource("Product Catalogue", withExtension: "momd")
        let mom = NSManagedObjectModel(contentsOfURL: modelURL!)

        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom!)
        var store = try! psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: self.storeURL!, options: nil)

        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = psc

        return managedObjectContext
    }()

    lazy var store: CoreDataStore = {
        return CoreDataStore(context: self.managedObjectContext)
    }()

    lazy var synchronizer: ContentfulSynchronizer = {
        let spaceId = ProductcatalogueKeys().productCatalogueSpaceId()
        let token = ProductcatalogueKeys().productCatalogueAccesToken()

        var configuration = Configuration()
        configuration.userAgentClient = "Contentful Product Catalogue/1.0"
        let client = Client(spaceIdentifier: spaceId, accessToken: token, configuration: configuration)

        let synchronizer = ContentfulSynchronizer(client: client, persistenceStore: self.store)

        synchronizer.mapAssets(to: Asset.self)
        synchronizer.mapSpaces(to: SyncInfo.self)

        synchronizer.map(contentTypeId: BrandContentTypeId, to: Brand.self)
        synchronizer.map(contentTypeId: CategoryContentTypeId, to: ProductCategory.self)
        synchronizer.map(contentTypeId: ProductContentTypeId, to: Product.self)

        return synchronizer
    }()

    func fetchedResultsController(forContentType type: Any.Type, predicate: NSPredicate, sortDescriptors: [NSSortDescriptor]) throws -> NSFetchedResultsController {
        let fetchRequest = try store.fetchRequest(type, predicate: predicate)
        fetchRequest.sortDescriptors = sortDescriptors
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    }

    func performSynchronization(completion: Bool -> ()) {
        self.synchronizer.sync(completion)
    }
}
