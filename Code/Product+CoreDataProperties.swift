//
//  Product+CoreDataProperties.swift
//  
//
//  Created by Boris Bügling on 03/05/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Product {

    @NSManaged var identifier: String?
    @NSManaged var price: NSNumber?
    @NSManaged var productDescription: String?
    @NSManaged var productName: String?
    @NSManaged var quantity: NSNumber?
    @NSManaged var sizetypecolor: String?
    @NSManaged var sku: String?
    @NSManaged var tags: NSData?
    @NSManaged var website: String?
    @NSManaged var brand: Brand?
    @NSManaged var categories: NSOrderedSet?
    @NSManaged var image: NSOrderedSet?

}
