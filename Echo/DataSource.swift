//
//  UserDataSource.swift
//  Echo
//
//  Created by Denis Ogun on 19/06/2016.
//  Copyright © 2016 Denis Ogun. All rights reserved.
//

import Foundation
import FirebaseDatabase
import SwiftyJSON

protocol DataSourceProtocol : class {
    func dataSourceDidUpdate()
}

class DataSource: NSObject {
    
    let databaseRef : FIRDatabaseReference
    
    override init() {
        self.databaseRef = FIRDatabase.database().reference()
        super.init()
    }
}

class UserDataSource : DataSource {
    
    var usersRef : FIRDatabaseReference?
    var users = [User]()
    weak var delegate : DataSourceProtocol?

    override init() {
        super.init()
        
        self.usersRef = self.databaseRef.child("users")
        self.listenForUserUpdates()
    }
    
    func listenForUserUpdates() {
        self.usersRef!.observeEventType(.Value, withBlock: { snapshot in
            
            var newUsers = [User]()
            
            for item in snapshot.children {
                if item is NSNull {
                    continue
                }
                
                let json = JSON(item.value!)
                print(json)
                let user = User(data : json)
                newUsers.append(user)
            }
            
            self.users = newUsers.sort({$0.userID < $1.userID})
            
            // Tell the delegate listener that there is a new data source
            self.delegate?.dataSourceDidUpdate()
        })
    }
    
    func getAllUsers() -> [User] {
        return users
    }
}
