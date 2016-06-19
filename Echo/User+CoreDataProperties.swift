//
//  User+CoreDataProperties.swift
//  Echo
//
//  Created by Denis Ogun on 19/06/2016.
//  Copyright © 2016 Denis Ogun. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var userID: NSNumber?
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var email: String?
    @NSManaged var birthDate: NSDate?

}
