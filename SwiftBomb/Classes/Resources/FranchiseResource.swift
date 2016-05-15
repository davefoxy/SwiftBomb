//
//  FranchiseResource.swift
//  SwiftBomb
//
//  Created by David Fox on 17/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

/**
 A class representing a *Franchise* on the Giant Bomb wiki. Examples include *Metal Gear Solid* and *Assassin's Creed*. 
 
 To retrieve extended info for a character, call `fetchExtendedInfo(_:)` upon it.
 */
final public class FranchiseResource: ResourceUpdating {
    
    /// The resource type.
    public let resourceType = ResourceType.Franchise
    
    /// Array of aliases the franchise is known by.
    public private(set) var aliases: [String]?
    
    /// URL pointing to the franchise detail resource.
    public private(set) var api_detail_url: NSURL?
    
    /// Date the franchise was added to Giant Bomb.
    public private(set) var date_added: NSDate?
    
    /// Date the franchise was last updated on Giant Bomb.
    public private(set) var date_last_updated: NSDate?
    
    /// Brief summary of the franchise.
    public private(set) var deck: String?
    
    /// Description of the franchise.
    public private(set) var description: String?
    
    /// Unique ID of the franchise.
    public let id: Int?
    
    /// Main image of the franchise.
    public private(set) var image: ImageURLs?
    
    /// Name of the franchise.
    public private(set) var name: String?
    
    /// URL pointing to the franchise on Giant Bomb.
    public private(set) var site_detail_url: NSURL?
    
    /// Extended info.
    public var extendedInfo: FranchiseExtendedInfo?
    
    /// Used to create a `FranchiseResource` from JSON.
    public init(json: [String : AnyObject]) {
        
        id = json["id"] as? Int

        update(json)
    }
    
    func update(json: [String : AnyObject]) {
        
        aliases = (json["aliases"] as? String)?.newlineSeparatedStrings() ?? aliases
        api_detail_url = (json["api_detail_url"] as? String)?.url() ?? api_detail_url
        date_added = (json["date_added"] as? String)?.dateRepresentation() ?? date_added
        date_last_updated = (json["date_last_updated"] as? String)?.dateRepresentation() ?? date_last_updated
        deck = json["deck"] as? String ?? deck
        description = json["description"] as? String ?? description
        name = json["name"] as? String ?? name
        site_detail_url = (json["site_detail_url"] as? String)?.url() ?? site_detail_url
        
        if let imageJSON = json["image"] as? [String: AnyObject] {
            image = ImageURLs(json: imageJSON)
        }
    }
    
    /// Pretty description of the franchise.
    public var prettyDescription: String {
        return name ?? "Franchise \(id)"
    }
}

/**
 Struct containing extended information for `FranchiseResource`s. To retrieve, call `fetchExtendedInfo(_:)` upon the original resource then access the data on the resource's `extendedInfo` property.
 */
public struct FranchiseExtendedInfo: ResourceExtendedInfo {
    
    /// Characters related to the franchise.
    public private(set) var characters: [CharacterResource]?
    
    /// Concepts related to the franchise.
    public private(set) var concepts: [ConceptResource]?
    
    /// Games the franchise has appeared in.
    public private(set) var games: [GameResource]?
    
    /// Locations related to the franchise.
    public private(set) var locations: [LocationResource]?
    
    /// Objects related to the franchise.
    public private(set) var objects: [ObjectResource]?
    
    /// People who have worked with the franchise.
    public private(set) var people: [PersonResource]?
    
    /// Used to create a `FranchiseExtendedInfo` from JSON.
    public init(json: [String : AnyObject]) {
        
        update(json)
    }
    
    /// A method used for updating structs. Usually after further requests for more field data.
    public mutating func update(json: [String : AnyObject]) {
        
        characters = json.jsonMappedResources("characters") ?? characters
        concepts = json.jsonMappedResources("concepts") ?? concepts
        games = json.jsonMappedResources("games") ?? games
        locations = json.jsonMappedResources("locations") ?? locations
        objects = json.jsonMappedResources("objects") ?? objects
        people = json.jsonMappedResources("people") ?? people
    }
}