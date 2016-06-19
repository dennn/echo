//
//  User.swift
//  Echo
//
//  Created by Denis Ogun on 19/06/2016.
//  Copyright © 2016 Denis Ogun. All rights reserved.
//

import Foundation
import CoreData
import Firebase

class User: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    convenience init (dataSnapshot: FIRDataSnapshot) {
        self.lastName = dataSnapshot[
    }
}
