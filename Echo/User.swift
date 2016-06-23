//
//  User.swift
//  Echo
//
//  Created by Denis Ogun on 20/06/2016.
//  Copyright © 2016 Denis Ogun. All rights reserved.
//

import Foundation
import JSONCodable

struct User : JSONDecodable, JSONEncodable, CustomStringConvertible {
    let userID : Int
    var firstName : String
    var lastName : String
    var fullName : String {
        get {
            return "\(self.firstName) \(self.lastName)"
        }
    }
    
    var email : String
    var dateOfBirth : NSDate
    var dateOfBirthString : String {
        get {
            return dateFormatter.stringFromDate(self.dateOfBirth)
        }
    }
    
    // Init from JSON Object
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        userID = try decoder.decode("userID")
        firstName = try decoder.decode("firstName")
        lastName = try decoder.decode("lastName")
        email = try decoder.decode("email")
        dateOfBirth = try decoder.decode("birthDate", transformer: stringToNSDate)
    }
    
    func toJSON() throws -> AnyObject {
        return try JSONEncoder.create({ (encoder) -> Void in
            try encoder.encode(userID, key: "userID")
            try encoder.encode(firstName, key: "firstName")
            try encoder.encode(lastName, key: "lastName")
            try encoder.encode(email, key: "email")
            try encoder.encode(dateOfBirth, key: "birthDate", transformer: stringToNSDate)
        })
    }
    
    var description: String {
        return "User with ID \(self.userID) and name \(self.firstName) \(self.lastName)"
    }
}

private let dateFormatter : NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "dd-MM-yyyy"
    return formatter
}()


let stringToNSDate = JSONTransformer<String, NSDate>(
    decoding: {dateFormatter.dateFromString($0)},
    encoding: {dateFormatter.stringFromDate($0)})

/*
class User : NSObject {
 
    var userID      : Int
    var firstName   : String
    var lastName    : String
    var email       : String
    var dateOfBirth : String
    
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
        self.dateOfBirth = data["birthDate"].stringValue
    }
    
    override var description: String {
        return "User with ID \(self.userID) and name \(self.firstName) \(self.lastName)"
    }
    
    func setNewDateOfBirth(date : NSDate) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yy"
        self.dateOfBirth = dateFormatter.stringFromDate(date)
    }
    
    func getDateOfBirth() -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yy"
        return dateFormatter.dateFromString(self.dateOfBirth)!
    }
}
*/