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
 
 To retrieve extended info for a concept, call `fetchExtendedInfo(_:)` upon it.
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
    
    /// Used to create a `ConceptResource` from JSON.
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
        
        if let firstAppearedInFranchiseJSON = json["first_appeared_in_franchise"] as? [String: AnyObject] {
            first_appeared_in_franchise = FranchiseResource(json: firstAppearedInFranchiseJSON)
        }
        
        if let firstAppearedInGameJSON = json["first_appeared_in_game"] as? [String: AnyObject] {
            first_appeared_in_game = GameResource(json: firstAppearedInGameJSON)
        }
        
        name = json["name"] as? String ?? name
        site_detail_url = (json["site_detail_url"] as? String)?.url() ?? site_detail_url
        
        if let imageJSON = json["image"] as? [String: AnyObject] {
            image = ImageURLs(json: imageJSON)
        }
    }
    
    /// Pretty description of the concept.
    public var prettyDescription: String {
        return name ?? "Concept \(id)"
    }
}

/**
 Struct containing extended information for `ConceptResource`s. To retrieve, call `fetchExtendedInfo(_:)` upon the original resource then access the data on the resource's `extendedInfo` property.
 */
public struct ConceptExtendedInfo: ResourceExtendedInfo {
    
    /// Characters related to the concept.
    public private(set) var characters: [CharacterResource]?
    
    /// Concepts related to the concept.
    public private(set) var concepts: [ConceptResource]?
    
    /// Franchises related to the concept.
    public private(set) var franchises: [FranchiseResource]?
    
    /// Games the concept has appeared in.
    public private(set) var games: [GameResource]?
    
    /// Locations related to the concept.
    public private(set) var locations: [LocationResource]?
    
    /// Objects related to the concept.
    public private(set) var objects: [ObjectResource]?
    
    /// People who have worked with the concept.
    public private(set) var people: [PersonResource]?
    
    /// Other concepts related to the concept.
    public private(set) var related_concepts: [ConceptResource]?
    
    /// Used to create a `ConceptExtendedInfo` from JSON.
    public init(json: [String : AnyObject]) {
        
        update(json)
    }
    
    /// A method used for updating structs. Usually after further requests for more field data.
    public mutating func update(json: [String : AnyObject]) {
        
        characters = json.jsonMappedResources("characters") ?? characters
        concepts = json.jsonMappedResources("concepts") ?? concepts
        franchises = json.jsonMappedResources("franchises") ?? franchises
        games = json.jsonMappedResources("games") ?? games
        locations = json.jsonMappedResources("locations") ?? locations
        objects = json.jsonMappedResources("objects") ?? objects
        people = json.jsonMappedResources("people") ?? people
        related_concepts = json.jsonMappedResources("related_concepts") ?? related_concepts
    }
}