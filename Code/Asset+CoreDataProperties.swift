//
//  Asset+CoreDataProperties.swift
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

extension Asset {

    @NSManaged var height: NSNumber?
    @NSManaged var identifier: String?
    @NSManaged var internetMediaType: String?
    @NSManaged var url: String?
    @NSManaged var width: NSNumber?
    @NSManaged var BrandInverse: NSSet?
    @NSManaged var CategoryInverse: NSSet?
    @NSManaged var ProductInverse: NSSet?

}
