//
//  SyncInfo+CoreDataProperties.swift
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

extension SyncInfo {

    @NSManaged var lastSyncTimestamp: NSDate?
    @NSManaged var syncToken: String?

}
