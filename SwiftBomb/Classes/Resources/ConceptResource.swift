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
    public let resourceType = ResourceType.concept
    
    /// Array of aliases the concept is known by.
    public fileprivate(set) var aliases: [String]?
    
    /// URL pointing to the concept detail resource.
    public fileprivate(set) var api_detail_url: URL?
    
    /// Date the concept was added to Giant Bomb.
    public fileprivate(set) var date_added: Date?
    
    /// Date the concept was last updated on Giant Bomb.
    public fileprivate(set) var date_last_updated: Date?
    
    /// Brief summary of the concept.
    public fileprivate(set) var deck: String?
    
    /// Description of the concept.
    public fileprivate(set) var description: String?
    
    /// Franchise where the concept made its first appearance.
    public fileprivate(set) var first_appeared_in_franchise: FranchiseResource?
    
    /// Game where the concept made its first appearance.
    public fileprivate(set) var first_appeared_in_game: GameResource?
    
    /// Unique ID of the concept.
    public fileprivate(set) var id: Int?
    
    /// Main image of the concept.
    public fileprivate(set) var image: ImageURLs?
    
    /// Name of the concept.
    public fileprivate(set) var name: String?
    
    /// URL pointing to the concept on Giant Bomb.
    public fileprivate(set) var site_detail_url: URL?
    
    /// Extended info.
    public var extendedInfo: ConceptExtendedInfo?
    
    /// Used to create a `ConceptResource` from JSON.
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
        
        if let firstAppearedInFranchiseJSON = json["first_appeared_in_franchise"] as? [String: AnyObject] {
            first_appeared_in_franchise = FranchiseResource(json: firstAppearedInFranchiseJSON)
        }
        
        if let firstAppearedInGameJSON = json["first_appeared_in_game"] as? [String: AnyObject] {
            first_appeared_in_game = GameResource(json: firstAppearedInGameJSON)
        }
        
        name = json["name"] as? String ?? name
        site_detail_url = (json["site_detail_url"] as? String)?.url() as URL?? ?? site_detail_url
        
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
    public fileprivate(set) var characters: [CharacterResource]?
    
    /// Concepts related to the concept.
    public fileprivate(set) var concepts: [ConceptResource]?
    
    /// Franchises related to the concept.
    public fileprivate(set) var franchises: [FranchiseResource]?
    
    /// Games the concept has appeared in.
    public fileprivate(set) var games: [GameResource]?
    
    /// Locations related to the concept.
    public fileprivate(set) var locations: [LocationResource]?
    
    /// Objects related to the concept.
    public fileprivate(set) var objects: [ObjectResource]?
    
    /// People who have worked with the concept.
    public fileprivate(set) var people: [PersonResource]?
    
    /// Other concepts related to the concept.
    public fileprivate(set) var related_concepts: [ConceptResource]?
    
    /// Used to create a `ConceptExtendedInfo` from JSON.
    public init(json: [String : AnyObject]) {
        
        update(json)
    }
    
    /// A method used for updating structs. Usually after further requests for more field data.
    public mutating func update(_ json: [String : AnyObject]) {
        
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
