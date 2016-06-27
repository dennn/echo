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
    var userID : Int?
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
    
    private var medications : String?
    var medicationList = Set<Int>() {
        didSet {
            self.convertMedicationList()
        }
    }
    
    // Init from JSON Object
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        firstName = try decoder.decode("firstName")
        lastName = try decoder.decode("lastName")
        email = try decoder.decode("email")
        dateOfBirth = try decoder.decode("birthDate", transformer: stringToNSDate)
        medications = try decoder.decode("medications")
        guard self.medications != nil else {
            return
        }
        medicationList = Set(self.medications!.componentsSeparatedByString(" ").flatMap({Int($0)}))
    }
    
    func toJSON() throws -> AnyObject {
        return try JSONEncoder.create({ (encoder) -> Void in
            try encoder.encode(firstName, key: "firstName")
            try encoder.encode(lastName, key: "lastName")
            try encoder.encode(email, key: "email")
            try encoder.encode(dateOfBirth, key: "birthDate", transformer: stringToNSDate)
            try encoder.encode(medications, key: "medications")
        })
    }
    
    mutating func convertMedicationList() {
        var newString = String()
        let medicationListSize = self.medicationList.count
        
        for (index, element) in self.medicationList.enumerate() {
            newString += String(element)
            if index + 1 != medicationListSize {
                newString += " "
            }
        }
        
        self.medications = newString
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


let stringToNSDate = JSONTransformer<String, NSDate> (
    decoding: {dateFormatter.dateFromString($0)},
    encoding: {dateFormatter.stringFromDate($0)})

/*let stringToIntArray = JSONTransformer<String, [String]> (
    decoding: {($0 as! String).componentsSeparatedByString(" ")},
    encoding: {dateFormatter.stringFromDate($0)})*/
