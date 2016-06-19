//
//  UserDataSource.swift
//  Echo
//
//  Created by Denis Ogun on 19/06/2016.
//  Copyright © 2016 Denis Ogun. All rights reserved.
//

import Foundation
import FirebaseDatabase

class UserDataSource: NSObject {
    
    let databaseRef, usersRef, medicationsRef : FIRDatabaseReference
    var users : Set<User> = Set()
    
    override init() {
        self.users = Set()
        FIRDatabase.database().reference().keepSynced(true)
        
        self.databaseRef = FIRDatabase.database().reference()
        self.usersRef = self.databaseRef.child("users")
        self.medicationsRef = self.databaseRef.child("medication")
        
        super.init()

        self.listenForUserUpdates()
        
    }
    
    func listenForUserUpdates() {
        self.usersRef.observeEventType(.Value, withBlock: { snapshot in
            print(snapshot.value)
            
        })
    }
    
    func getAllUsers() -> String {
        return "Fuck off"
    }
}
