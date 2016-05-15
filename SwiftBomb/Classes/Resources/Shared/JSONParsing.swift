//
//  JSONParsing.swift
//  SwiftBomb
//
//  Created by David Fox on 17/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

extension Array where Element: CollectionType {
    
    func idNameTupleMaps() -> [(id: Int, name: String)] {
        
        var tuples = [(id: Int, name: String)]()
        for object in self {
            
            if
                let stringObjectDict = object as? [String: AnyObject],
                let tuple = stringObjectDict.idNameTupleMap() {
                tuples.append(tuple)
            }
        }
        
        return tuples
    }
}

extension Dictionary where Key: StringLiteralConvertible, Value: AnyObject {
    
    /**
     Returns an array of resources from a json payload containing a subarray found within `key`
     */
    func jsonMappedResources<T: Resource>(key: Key) -> [T]? {
        
        if let arrayJSON = self[key] as? [[String: AnyObject]] {
            
            var resources = [T]()
            
            resources = arrayJSON.map({ resourceJSON in
                return T(json: resourceJSON)
            })
            
            return resources
        }
        
        return nil
    }
    
    /**
     Optionally returns a tuple of type `(id: Int, name: String)`
     */
    func idNameTupleMap() -> (id: Int, name: String)? {
        
        if
            let id = self["id"] as? Int,
            let name = self["name"] as? String {
            return (id: id, name: name)
        }
        else {
            
            return nil
        }
    }
}

extension String {
    
    /**
     Some of the image names in the Giant Bomb database appear to be missing their host and path from time-to-time. This just adds it if it's missing. Nasty but seems the database is a little inconsistent in places
     */
    func safeGBImageURL() -> NSURL? {
        if (self.hasPrefix("http")) {
            return NSURL(string: self)
        }
        return NSURL(string: "http://static.giantbomb.com/\(self)")
    }
    
    /**
     Returns an NSURL from the string (if possible)
     */
    func url() -> NSURL? {
        
        return NSURL(string: self)
    }
    
    /**
     Splits and returns an array of objects which are separated by a new line. Used in parsing the common `aliases` property
     */
    func newlineSeparatedStrings() -> [String] {
        
        let cleaned = self.stringByReplacingOccurrencesOfString("\r\n", withString: "\n")
        return cleaned.componentsSeparatedByString("\n")
    }
    
    /**
     Creates a date from strings defined in things like created_at etc
     */
    func dateRepresentation() -> NSDate? {
        
        return String.dateFormatter.dateFromString(self)
    }
    
    /**
     Creates a date from short date strings defined in things like birthdays
     */
    func shortDateRepresentation() -> NSDate? {
        
        guard let date = String.shortDateFormatter.dateFromString(self) else {
            return nil
        }
        return date
    }
    
    /**
     A date formatter used to parse string dates to native NSDate objects. The API always uses the date format `2006-05-07 14:20:53`
     */
    private static let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        return formatter
    }()
    
    /**
     A date formatter used to parse short string dates to native NSDate objects. Used for fields like birthdays. Uses the format `YY-MM-dd`
     */
    private static let shortDateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }()
}