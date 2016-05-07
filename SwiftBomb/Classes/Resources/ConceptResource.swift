//
//  ConceptResource.swift
//  SwiftBomb
//
//  Created by David Fox on 16/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

/**
 A class representing a *Concept* on the Giant Bomb wiki. Examples include *Free To Play* and *Quick Time Event*.
 
 To retrieve extended info for a concept, call `fetchExtendedInfo(completion: (error: RequestError?)` upon it.
 */
final public class ConceptResource: ResourceUpdating {
    
    /// The resource type.
    public let resourceType = ResourceType.Concept
    
    /// Array of aliases the concept is known by.
    public private(set) var aliases: [String]?
    
    /// URL pointing to the concept detail resource.
    public private(set) var api_detail_url: NSURL?
    
    /// Date the concept was added to Giant Bomb.
    public private(set) var date_added: NSDate?
    
    /// Date the concept was last updated on Giant Bomb.
    public private(set) var date_last_updated: NSDate?
    
    /// Brief summary of the concept.
    public private(set) var deck: String?
    
    /// Description of the concept.
    public private(set) var description: String?
    
    /// Franchise where the concept made its first appearance.
    public private(set) var first_appeared_in_franchise: FranchiseResource?
    
    /// Game where the concept made its first appearance.
    public private(set) var first_appeared_in_game: GameResource?
    
    /// Unique ID of the concept.
    public private(set) var id: Int?
    
    /// Main image of the concept.
    public private(set) var image: ImageURLs?
    
    /// Name of the concept.
    public private(set) var name: String?
    
    /// URL pointing to the concept on Giant Bomb.
    public private(set) var site_detail_url: NSURL?
    
    /// Extended info.
    public var extendedInfo: ConceptExtendedInfo?
    
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
        
        if let firstAppearedInFranchiseJSON = json["first_appeared_in_franchise"] as? [String: AnyObject] {
            first_appeared_in_franchise = FranchiseResource(json: firstAppearedInFranchiseJSON)
        } else {
            first_appeared_in_franchise = nil
        }
        
        if let firstAppearedInGameJSON = json["first_appeared_in_game"] as? [String: AnyObject] {
            first_appeared_in_game = GameResource(json: firstAppearedInGameJSON)
        } else {
            first_appeared_in_game = nil
        }
        
        name = json["name"] as? String
        site_detail_url = (json["site_detail_url"] as? String)?.url()
        
        if let imageJSON = json["image"] as? [String: AnyObject] {
            image = ImageURLs(json: imageJSON)
        } else {
            image = nil
        }
    }
    
    public var prettyDescription: String {
        return name ?? "Concept \(id)"
    }
}

/**
 Struct containing extended information for `ConceptResource`s. To retrieve, call `fetchExtendedInfo(completion: (error: RequestError?)` upon the original resource then access the data on the resource's `extendedInfo` property.
 */
public struct ConceptExtendedInfo: ResourceExtendedInfo {
    
    /// Characters related to the concept.
    public let characters: [CharacterResource]
    
    /// Concepts related to the concept.
    public let concepts: [ConceptResource]
    
    /// Franchises related to the concept.
    public let franchises: [FranchiseResource]
    
    /// Games the concept has appeared in.
    public let games: [GameResource]
    
    /// Locations related to the concept.
    public let locations: [LocationResource]
    
    /// Objects related to the concept.
    public let objects: [ObjectResource]
    
    /// People who have worked with the concept.
    public let people: [PersonResource]
    
    /// Other concepts related to the concept.
    public let related_concepts: [ConceptResource]
    
    public init(json: [String : AnyObject]) {
        
        characters = json.jsonMappedResources("characters")
        concepts = json.jsonMappedResources("concepts")
        franchises = json.jsonMappedResources("franchises")
        games = json.jsonMappedResources("games")
        locations = json.jsonMappedResources("locations")
        objects = json.jsonMappedResources("objects")
        people = json.jsonMappedResources("people")
        related_concepts = json.jsonMappedResources("related_concepts")
    }
}