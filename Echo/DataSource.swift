//
//  UserDataSource.swift
//  Echo
//
//  Created by Denis Ogun on 19/06/2016.
//  Copyright © 2016 Denis Ogun. All rights reserved.
//

import Foundation
import FirebaseDatabase
import CoreData
import JSONCodable

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
            
            do {
                var newUsers = [User]()
                
                for item in snapshot.children.allObjects as! [FIRDataSnapshot] {
                    if item.value is Dictionary<String, AnyObject> {
                        print (item.value)
                        let user = try User(object: item.value! as! JSONObject)
                        print(user)
                        newUsers.append(user)
                    } else {
                        print("The data structure is not a dictionary...")
                    }
                }
                
                self.users = newUsers.sort({$0.userID < $1.userID})
                
                // Tell the delegate listener that there is a new data source
                self.delegate?.dataSourceDidUpdate()
            } catch {
                print("Error decoding JSON dictionary")
            }
        })
    }
    
    func getAllUsers() -> [User] {
        return users
    }
    
    func saveUser(user : User!) {
        let userRef = self.usersRef!.child("\(user.userID)")
        do {
            let userJSON = try user.toJSON()
            print(userJSON)
            
            userRef.updateChildValues(userJSON as! [NSObject : AnyObject]) { (err, ref) in
                if err != nil {
                    print(err!.localizedDescription)
                }
            }
        } catch {
            print("Error encoding the user as a JSON object")
        }
    }
}
