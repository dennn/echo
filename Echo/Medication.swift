//
//  Medication.swift
//  Echo
//
//  Created by Denis Ogun on 25/06/2016.
//  Copyright © 2016 Denis Ogun. All rights reserved.
//

import Foundation
import JSONCodable

struct Medication : JSONDecodable, JSONEncodable {
    var id : Int?
    var category : String
    var detail : String
    var name : String
    
    // Init from JSON Object
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        category = try decoder.decode("category")
        detail = try decoder.decode("detail")
        name = try decoder.decode("name")
    }
    
    func toJSON() throws -> AnyObject {
        return try JSONEncoder.create({ (encoder) -> Void in
            try encoder.encode(category, key: "category")
            try encoder.encode(detail, key: "detail")
            try encoder.encode(name, key: "name")
        })
    }
    
    var description: String {
        return "Medication with ID \(self.id) and name \(self.name)"
    }
}
