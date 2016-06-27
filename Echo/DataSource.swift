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
            
                var newUsers = [User]()
                
                for item in snapshot.children.allObjects as! [FIRDataSnapshot] {
                    do {

                        if item.value is Dictionary<String, AnyObject> {
                            print (item.value)
                            var user = try User(object: item.value! as! JSONObject)
                            user.userID = Int(item.key)
                            print(user)
                            newUsers.append(user)
                        } else {
                            print("The data structure is not a dictionary...")
                        }
                    } catch {
                        print("Error decoding user JSON dictionary")
                    }
            
                self.users = newUsers.sort({$0.userID < $1.userID})
                
                // Tell the delegate listener that there is a new data source
                self.delegate?.dataSourceDidUpdate()
            }
        })
    }
    
    func getAllUsers() -> [User] {
        return users
    }
    
    func saveUser(user : User!) {
        // Push the changes to the cloud
        let userRef = self.usersRef!.child("\(user.userID!)")
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

class MedicationDataSource : DataSource {
    
    var medicationRef : FIRDatabaseReference?
    var medications = [Medication]()
    weak var delegate : DataSourceProtocol?
    
    override init() {
        super.init()
        
        self.medicationRef = self.databaseRef.child("medications")
        self.listenForMedicationUpdates()
        
    }
    
    func listenForMedicationUpdates() {
        self.medicationRef!.observeEventType(.Value, withBlock: { snapshot in
                var newMedications = [Medication]()
                
                for item in snapshot.children.allObjects as! [FIRDataSnapshot] {
                    do {
                        if item.value is Dictionary<String, AnyObject> {
                            print (item.value)
                            var medication = try! Medication(object: item.value! as! JSONObject)
                            medication.id = Int(item.key)
                            print(medication)
                            newMedications.append(medication)
                        } else {
                            print("The data structure is not a dictionary...")
                        }
                    } catch {
                        print("Error decoding medication JSON dictionary")
                    }
                }
            
            self.medications = newMedications
            
            // Tell the delegate listener that there is a new data source
            self.delegate?.dataSourceDidUpdate()

        })
    }
    
    func getAllMedications() -> [Medication] {
        return self.medications
    }
    
    func getMedicationForID(id : Int) -> Medication {
        return self.medications[id]
    }
}
