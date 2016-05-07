//
//  JSONMappingEnums.swift
//  GBAPI
//
//  Created by David Fox on 22/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

// Definition of a standard string to anyobject dictionary mapping
typealias JSONDict = [String: AnyObject]

/// Enum to define a character's gender. Used for strong-typing the `gender` variable
public enum Gender: Int {
    case Unknown = 0, Male, Female, Other
    
    public var description: String {
        get {
            switch self {
            case Unknown:
                return "Unknown"
                
            case Male:
                return "Male"
                
            case Female:
                return "Female"
                
            case Other:
                return "Other"
            }
        }
    }
}

