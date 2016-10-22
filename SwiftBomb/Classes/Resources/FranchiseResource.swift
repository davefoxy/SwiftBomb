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
    public let resourceType = ResourceType.franchise
    
    /// Array of aliases the franchise is known by.
    public fileprivate(set) var aliases: [String]?
    
    /// URL pointing to the franchise detail resource.
    public fileprivate(set) var api_detail_url: URL?
    
    /// Date the franchise was added to Giant Bomb.
    public fileprivate(set) var date_added: Date?
    
    /// Date the franchise was last updated on Giant Bomb.
    public fileprivate(set) var date_last_updated: Date?
    
    /// Brief summary of the franchise.
    public fileprivate(set) var deck: String?
    
    /// Description of the franchise.
    public fileprivate(set) var description: String?
    
    /// Unique ID of the franchise.
    public let id: Int?
    
    /// Main image of the franchise.
    public fileprivate(set) var image: ImageURLs?
    
    /// Name of the franchise.
    public fileprivate(set) var name: String?
    
    /// URL pointing to the franchise on Giant Bomb.
    public fileprivate(set) var site_detail_url: URL?
    
    /// Extended info.
    public var extendedInfo: FranchiseExtendedInfo?
    
    /// Used to create a `FranchiseResource` from JSON.
    public init(json: [String : AnyObject]) {
        
        id = json["id"] as? Int

        update(json: json)
    }
    
    func update(json: [String : AnyObject]) {
        
        aliases = (json["aliases"] as? String)?.newlineSeparatedStrings() ?? aliases
        api_detail_url = (json["api_detail_url"] as? String)?.url() as URL?? ?? api_detail_url
        date_added = (json["date_added"] as? String)?.dateRepresentation() as Date?? ?? date_added
        date_last_updated = (json["date_last_updated"] as? String)?.dateRepresentation() as Date?? ?? date_last_updated
        deck = json["deck"] as? String ?? deck
        description = json["description"] as? String ?? description
        name = json["name"] as? String ?? name
        site_detail_url = (json["site_detail_url"] as? String)?.url() as URL?? ?? site_detail_url
        
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
    public fileprivate(set) var characters: [CharacterResource]?
    
    /// Concepts related to the franchise.
    public fileprivate(set) var concepts: [ConceptResource]?
    
    /// Games the franchise has appeared in.
    public fileprivate(set) var games: [GameResource]?
    
    /// Locations related to the franchise.
    public fileprivate(set) var locations: [LocationResource]?
    
    /// Objects related to the franchise.
    public fileprivate(set) var objects: [ObjectResource]?
    
    /// People who have worked with the franchise.
    public fileprivate(set) var people: [PersonResource]?
    
    /// Used to create a `FranchiseExtendedInfo` from JSON.
    public init(json: [String : AnyObject]) {
        
        update(json)
    }
    
    /// A method used for updating structs. Usually after further requests for more field data.
    public mutating func update(_ json: [String : AnyObject]) {
        
        characters = json.jsonMappedResources("characters") ?? characters
        concepts = json.jsonMappedResources("concepts") ?? concepts
        games = json.jsonMappedResources("games") ?? games
        locations = json.jsonMappedResources("locations") ?? locations
        objects = json.jsonMappedResources("objects") ?? objects
        people = json.jsonMappedResources("people") ?? people
    }
}
