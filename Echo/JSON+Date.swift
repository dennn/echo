//
//  JSON+Date.swift
//  Echo
//
//  Created by Denis Ogun on 20/06/2016.
//  Copyright © 2016 Denis Ogun. All rights reserved.
//

import Foundation
import SwiftyJSON

// https://github.com/SwiftyJSON/SwiftyJSON/issues/421

extension JSON {
    
    public var date: NSDate? {
        get {
            switch self.type {
            case .String:
                return Formatter.jsonDateFormatter.dateFromString(self.object as! String)
            default:
                return nil
            }
        }
    }
}

class Formatter {
    
    private static var internalJsonDateFormatter: NSDateFormatter?
    private static var internalJsonDateTimeFormatter: NSDateFormatter?
    
    static var jsonDateFormatter: NSDateFormatter {
        if (internalJsonDateFormatter == nil) {
            internalJsonDateFormatter = NSDateFormatter()
            internalJsonDateFormatter!.dateFormat = "dd-MM-yyyy"
        }
        return internalJsonDateFormatter!
    }
}