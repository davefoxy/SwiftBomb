//
//  ObjectResource.swift
//  SwiftBomb
//
//  Created by David Fox on 25/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

/**
 A class representing an *Object* on the Giant Bomb wiki. Examples include *Map* and *Teleporter*.
 
 To retrieve extended info for an object, call `fetchExtendedInfo(_:)` upon it.
 */
final public class ObjectResource: ResourceUpdating {
    
    /// The resource type.
    public let resourceType = ResourceType.object
    
    /// Array of aliases the object is known by.
    public fileprivate(set) var aliases: [String]?
    
    /// URL pointing to the object detail resource.
    public fileprivate(set) var api_detail_url: URL?
    
    /// Date the object was added to Giant Bomb.
    public fileprivate(set) var date_added: Date?
    
    /// Date the object was last updated on Giant Bomb.
    public fileprivate(set) var date_last_updated: Date?
    
    /// Brief summary of the object.
    public fileprivate(set) var deck: String?
    
    /// Description of the object.
    public fileprivate(set) var description: String?
    
    /// Game where the object made its first appearance.
    public fileprivate(set) var first_appeared_in_game: GameResource?
    
    /// Unique ID of the object.
    public let id: Int?
    
    /// Main image of the object.
    public fileprivate(set) var image: ImageURLs?
    
    /// Name of the object.
    public fileprivate(set) var name: String?
    
    /// URL pointing to the object on Giant Bomb.
    public fileprivate(set) var site_detail_url: URL?
    
    /// Extended info.
    public var extendedInfo: ObjectExtendedInfo?
    
    /// Used to create a `ObjectResource` from JSON.
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
        
        if let firstAppearedInGameJSON = json["first_appeared_in_game"] as? [String: AnyObject] {
            first_appeared_in_game = GameResource(json: firstAppearedInGameJSON)
        }
        
        if let imageJSON = json["image"] as? [String: AnyObject] {
            image = ImageURLs(json: imageJSON)
        }
        
        name = json["name"] as? String ?? name
        site_detail_url = (json["site_detail_url"] as? String)?.url() as URL?? ?? site_detail_url
    }
    
    /// Pretty description of the object.
    public var prettyDescription: String {
        return name ?? "Character \(id)"
    }
}

/**
 Struct containing extended information for `ObjectResource`s. To retrieve, call `fetchExtendedInfo(_:)` upon the original resource then access the data on the resource's `extendedInfo` property.
 */
public struct ObjectExtendedInfo: ResourceExtendedInfo {
    
    /// Characters related to the object.
    public fileprivate(set) var characters: [CharacterResource]?
    
    /// Companies related to the object.
    public fileprivate(set) var companies: [CompanyResource]?
    
    /// Concepts related to the object.
    public fileprivate(set) var concepts: [ConceptResource]?
    
    /// Franchises related to the object.
    public fileprivate(set) var franchises: [FranchiseResource]?
    
    /// Games the object has appeared in.
    public fileprivate(set) var games: [GameResource]?
    
    /// Locations related to the object.
    public fileprivate(set) var locations: [LocationResource]?
    
    /// Objects related to the object.
    public fileprivate(set) var objects: [ObjectResource]?
    
    /// People who have worked with the object.
    public fileprivate(set) var people: [PersonResource]?
    
    /// Used to create a `ObjectExtendedInfo` from JSON.
    public init(json: [String : AnyObject]) {
        
        update(json)
    }
    
    /// A method used for updating structs. Usually after further requests for more field data.
    public mutating func update(_ json: [String : AnyObject]) {
        
        characters = json.jsonMappedResources("characters") ?? characters
        companies = json.jsonMappedResources("companies") ?? companies
        concepts = json.jsonMappedResources("concepts") ?? concepts
        franchises = json.jsonMappedResources("franchises") ?? franchises
        games = json.jsonMappedResources("games") ?? games
        locations = json.jsonMappedResources("locations") ?? locations
        objects = json.jsonMappedResources("objects") ?? objects
        people = json.jsonMappedResources("people") ?? people
    }
}
