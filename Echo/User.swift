//
//  User.swift
//  Echo
//
//  Created by Denis Ogun on 20/06/2016.
//  Copyright © 2016 Denis Ogun. All rights reserved.
//

import Foundation
import SwiftyJSON

class User : NSObject {
    
    var userID      : Int
    var firstName   : String
    var lastName    : String
    var email       : String
    var dateOfBirth : NSDate?
    
    var fullName : String {
        get {
            return "\(self.firstName) \(self.lastName)"
        }
    }
    
    init(data : JSON) {
        self.userID = data["userID"].intValue
        self.firstName = data["firstName"].stringValue
        self.lastName = data["lastName"].stringValue
        self.email = data["email"].stringValue
        self.dateOfBirth = data["birthDate"].date
    }
    
    override var description: String {
        return "User with ID \(self.userID) and name \(self.firstName) \(self.lastName)"
    }
}
