//
//  JSONParsing.swift
//  SwiftBomb
//
//  Created by David Fox on 17/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

extension Array where Element: Collection {
    
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

extension Dictionary where Key: ExpressibleByStringLiteral, Value: AnyObject {
    
    /**
     Returns an array of resources from a json payload containing a subarray found within `key`
     */
    func jsonMappedResources<T: Resource>(_ key: Key) -> [T]? {
        
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
    func safeGBImageURL() -> URL? {
        if (self.hasPrefix("http")) {
            return URL(string: self)
        }
        return URL(string: "http://static.giantbomb.com/\(self)")
    }
    
    /**
     Returns an NSURL from the string (if possible)
     */
    func url() -> URL? {
        
        return URL(string: self)
    }
    
    /**
     Splits and returns an array of objects which are separated by a new line. Used in parsing the common `aliases` property
     */
    func newlineSeparatedStrings() -> [String] {
        
        let cleaned = self.replacingOccurrences(of: "\r\n", with: "\n")
        return cleaned.components(separatedBy: "\n")
    }
    
    /**
     Creates a date from strings defined in things like created_at etc
     */
    func dateRepresentation() -> Date? {
        
        return String.dateFormatter.date(from: self)
    }
    
    /**
     Creates a date from short date strings defined in things like birthdays
     */
    func shortDateRepresentation() -> Date? {
        
        guard let date = String.shortDateFormatter.date(from: self) else {
            return nil
        }
        return date
    }
    
    /**
     Creates a date from the dates returned in the `ComingUpItemResource` fetch
     */
    func comingUpItemDateRepresentation() -> Date? {
        
        guard let date = String.comingUpItemDateFormatter.date(from: self) else {
            return nil
        }
        return date
    }
    
    /**
     A date formatter used to parse string dates to native NSDate objects. The API always uses the date format `2006-05-07 14:20:53`
     */
    fileprivate static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    /**
     A date formatter used to parse short string dates to native NSDate objects. Used for fields like birthdays. Uses the format `YY-MM-dd`
     */
    fileprivate static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    /**
     A date formatter used to parse date/time string dates to native NSDate objects. Used for parsing `ComingUpItemResource` objects.
     */
    fileprivate static let comingUpItemDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd',' yyyy hh:mm a"
        formatter.timeZone = TimeZone(abbreviation: "PDT")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
