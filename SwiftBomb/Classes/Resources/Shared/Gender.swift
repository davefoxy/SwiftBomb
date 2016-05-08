//
//  Gender.swift
//  Pods
//
//  Created by David Fox on 08/05/2016.
//
//

import Foundation

/// Enum to define a `CharacterResource` or `PersonResource`'s gender.
public enum Gender: Int {
    
    /// The gender could not be inferred from the Giant Bomb API.
    case Unknown = 0
    
    /// Male
    case Male
    
    /// Female
    case Female
    
    /// Other. Used for characters like robots or other entities without a sex.
    case Other
    
    /// Returns a user-facing representation of the gender.
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
