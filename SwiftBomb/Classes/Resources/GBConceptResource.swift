//
//  GBConceptResource.swift
//  GBAPI
//
//  Created by David Fox on 16/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

final public class GBConceptResource: GBResourceUpdating {
    
    /// The resource type
    public let resourceType = ResourceType.Concept
    
    /// Array of aliases the concept is known by
    public private(set) var aliases: [String]?
    
    /// URL pointing to the concept detail resource
    public private(set) var api_detail_url: NSURL?
    
    /// Date the concept was added to Giant Bomb
    public private(set) var date_added: NSDate?
    
    /// Date the concept was last updated on Giant Bomb
    public private(set) var date_last_updated: NSDate?
    
    /// Brief summary of the concept
    public private(set) var deck: String?
    
    /// Description of the concept
    public private(set) var description: String?
    
    /// Franchise where the concept made its first appearance
    public private(set) var first_appeared_in_franchise: GBFranchiseResource?
    
    /// Game where the concept made its first appearance
    public private(set) var first_appeared_in_game: GBGameResource?
    
    /// Unique ID of the concept
    public private(set) var id: Int?
    
    /// Main image of the concept
    public private(set) var image: GBImageURLs?
    
    /// Name of the concept
    public private(set) var name: String?
    
    /// URL pointing to the concept on Giant Bomb
    public private(set) var site_detail_url: NSURL?
    
    /// Extended info
    public var extendedInfo: GBConceptExtendedInfo?
    
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
            first_appeared_in_franchise = GBFranchiseResource(json: firstAppearedInFranchiseJSON)
        } else {
            first_appeared_in_franchise = nil
        }
        
        if let firstAppearedInGameJSON = json["first_appeared_in_game"] as? [String: AnyObject] {
            first_appeared_in_game = GBGameResource(json: firstAppearedInGameJSON)
        } else {
            first_appeared_in_game = nil
        }
        
        name = json["name"] as? String
        site_detail_url = (json["site_detail_url"] as? String)?.url()
        
        if let imageJSON = json["image"] as? [String: AnyObject] {
            image = GBImageURLs(json: imageJSON)
        } else {
            image = nil
        }
    }
    
    public var prettyDescription: String {
        return name ?? "Concept \(id)"
    }
}

public struct GBConceptExtendedInfo: GBResourceExtendedInfo {
    
    /// Characters related to the concept
    public let characters: [GBCharacterResource]
    
    /// Concepts related to the concept
    public let concepts: [GBConceptResource]
    
    /// Franchises related to the concept
    public let franchises: [GBFranchiseResource]
    
    /// Games the concept has appeared in
    public let games: [GBGameResource]
    
    /// Locations related to the concept
    public let locations: [GBLocationResource]
    
    /// Objects related to the concept
    public let objects: [GBObjectResource]
    
    /// People who have worked with the concept
    public let people: [GBPersonResource]
    
    /// Other concepts related to the concept
    public let related_concepts: [GBConceptResource]
    
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