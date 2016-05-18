//
//  Brand+CoreDataProperties.swift
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

extension Brand {

    @NSManaged var companyDescription: String?
    @NSManaged var companyName: String?
    @NSManaged var email: String?
    @NSManaged var identifier: String?
    @NSManaged var twitter: String?
    @NSManaged var website: String?
    @NSManaged var brandInverse: NSSet?
    @NSManaged var logo: Asset?

}
