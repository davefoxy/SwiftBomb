//
//  GBFranchiseResource.swift
//  GBAPI
//
//  Created by David Fox on 17/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

final public class GBFranchiseResource: GBResourceUpdating {
    
    /// The resource type
    public let resourceType = ResourceType.Franchise
    
    /// Array of aliases the franchise is known by. A \n (newline) seperates each alias
    public private(set) var aliases: [String]?
    
    /// URL pointing to the franchise detail resource
    public private(set) var api_detail_url: NSURL?
    
    /// Date the franchise was added to Giant Bomb
    public private(set) var date_added: NSDate?
    
    /// Date the franchise was last updated on Giant Bomb
    public private(set) var date_last_updated: NSDate?
    
    /// Brief summary of the franchise
    public private(set) var deck: String?
    
    /// Description of the franchise
    public private(set) var description: String?
    
    /// Unique ID of the franchise
    public let id: Int?
    
    /// Main image of the franchise
    public private(set) var image: GBImageURLs?
    
    /// Name of the franchise
    public private(set) var name: String?
    
    /// URL pointing to the franchise on Giant Bomb
    public private(set) var site_detail_url: NSURL?
    
    /// Extended info
    public var extendedInfo: GBFranchiseExtendedInfo?
    
    public init(json: [String : AnyObject]) {
        
        id = json["id"] as? Int

        update(json)
    }
    
    func update(json: [String : AnyObject]) {
        
        if let aliasesString = json["aliases"] as? String {
            aliases = aliasesString.componentsSeparatedByString("\n")
        } else {
            aliases = [String]()
        }
        
        api_detail_url = (json["api_detail_url"] as? String)?.url()
        date_added = (json["date_added"] as? String)?.dateRepresentation()
        date_last_updated = (json["date_last_updated"] as? String)?.dateRepresentation()
        deck = json["deck"] as? String
        description = json["description"] as? String
        name = json["name"] as? String
        site_detail_url = (json["site_detail_url"] as? String)?.url()
        
        if let imageJSON = json["image"] as? [String: AnyObject] {
            image = GBImageURLs(json: imageJSON)
        } else {
            image = nil
        }
    }
    
    public var prettyDescription: String {
        return name ?? "Franchise \(id)"
    }
}

public struct GBFranchiseExtendedInfo: GBResourceExtendedInfo {
    
    /// Characters related to the franchise
    public let characters: [GBCharacterResource]
    
    /// Concepts related to the franchise
    public let concepts: [GBConceptResource]
    
    /// Games the franchise has appeared in
    public let games: [GBGameResource]
    
    /// Locations related to the franchise
    public let locations: [GBLocationResource]
    
    /// Objects related to the franchise
    public let objects: [GBObjectResource]
    
    /// People who have worked with the franchise
    public let people: [GBPersonResource]

    public init(json: [String : AnyObject]) {
        
        characters = json.jsonMappedResources("characters")
        concepts = json.jsonMappedResources("concepts")
        games = json.jsonMappedResources("games")
        locations = json.jsonMappedResources("locations")
        objects = json.jsonMappedResources("objects")
        people = json.jsonMappedResources("people")
    }
}