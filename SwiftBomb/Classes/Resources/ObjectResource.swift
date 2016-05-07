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
 
 To retrieve extended info for an object, call `fetchExtendedInfo(completion: (error: RequestError?)` upon it.
 */
final public class ObjectResource: ResourceUpdating {
    
    /// The resource type.
    public let resourceType = ResourceType.Object
    
    /// Array of aliases the object is known by.
    public private(set) var aliases: [String]?
    
    /// URL pointing to the object detail resource.
    public private(set) var api_detail_url: NSURL?
    
    /// Date the object was added to Giant Bomb.
    public private(set) var date_added: NSDate?
    
    /// Date the object was last updated on Giant Bomb.
    public private(set) var date_last_updated: NSDate?
    
    /// Brief summary of the object.
    public private(set) var deck: String?
    
    /// Description of the object.
    public private(set) var description: String?
    
    /// Game where the object made its first appearance.
    public private(set) var first_appeared_in_game: GameResource?
    
    /// Unique ID of the object.
    public let id: Int?
    
    /// Main image of the object.
    public private(set) var image: ImageURLs?
    
    /// Name of the object.
    public private(set) var name: String?
    
    /// URL pointing to the object on Giant Bomb.
    public private(set) var site_detail_url: NSURL?
    
    /// Extended info.
    public var extendedInfo: ObjectExtendedInfo?
    
    public init(json: [String : AnyObject]) {
        
        id = json["id"] as? Int

        update(json)
    }
    
    func update(json: [String : AnyObject]) {
        
        aliases = (json["aliases"] as? String)?.newlineSeparatedStrings()
        api_detail_url = (json["api_detail_url"] as? String)?.url()
        date_added = (json["date_added"] as? String)?.dateRepresentation()
        date_last_updated = (json["date_last_updated"] as? String)?.dateRepresentation()
        deck = json["deck"] as? String
        description = json["description"] as? String
        
        if let firstAppearedInGameJSON = json["first_appeared_in_game"] as? [String: AnyObject] {
            first_appeared_in_game = GameResource(json: firstAppearedInGameJSON)
        } else {
            first_appeared_in_game = nil
        }
        
        if let imageJSON = json["image"] as? [String: AnyObject] {
            image = ImageURLs(json: imageJSON)
        } else {
            image = nil
        }
        
        name = json["name"] as? String
        site_detail_url = (json["site_detail_url"] as? String)?.url()
    }
    
    public var prettyDescription: String {
        return name ?? "Character \(id)"
    }
}

/**
 Struct containing extended information for `ObjectResource`s. To retrieve, call `fetchExtendedInfo(completion: (error: RequestError?)` upon the original resource then access the data on the resource's `extendedInfo` property.
 */
public struct ObjectExtendedInfo: ResourceExtendedInfo {
    
    /// Characters related to the object.
    public let characters: [CharacterResource]
    
    /// Companies related to the object.
    public let companies: [CompanyResource]
    
    /// Concepts related to the object.
    public let concepts: [ConceptResource]
    
    /// Franchises related to the object.
    public let franchises: [FranchiseResource]
    
    /// Games the object has appeared in.
    public let games: [GameResource]
    
    /// Locations related to the object.
    public let locations: [LocationResource]
    
    /// Objects related to the object.
    public let objects: [ObjectResource]
    
    /// People who have worked with the object.
    public let people: [PersonResource]
    
    public init(json: [String : AnyObject]) {
        
        characters = json.jsonMappedResources("characters")
        companies = json.jsonMappedResources("companies")
        concepts = json.jsonMappedResources("concepts")
        franchises = json.jsonMappedResources("franchises")
        games = json.jsonMappedResources("games")
        locations = json.jsonMappedResources("locations")
        objects = json.jsonMappedResources("objects")
        people = json.jsonMappedResources("people")
    }
}