//
//  Gender.swift
//  SwiftBomb
//
//  Created by David Fox on 08/05/2016.
//
//

import Foundation

/// Enum to define a `CharacterResource` or `PersonResource`'s gender.
public enum Gender: Int {
    
    /// The gender could not be inferred from the Giant Bomb API.
    case unknown = 0
    
    /// Male
    case male
    
    /// Female
    case female
    
    /// Other. Used for characters like robots or other entities without a sex.
    case other
    
    /// Returns a user-facing representation of the gender.
    public var description: String {
        get {
            switch self {
            case .unknown:
                return "Unknown"
                
            case .male:
                return "Male"
                
            case .female:
                return "Female"
                
            case .other:
                return "Other"
            }
        }
    }
}
