//
//  GBLocationResource.swift
//  GBAPI
//
//  Created by David Fox on 25/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

final public class GBLocationResource: GBResourceUpdating {
    
    /// The resource type
    public let resourceType = ResourceType.Location
    
    /// An array of aliases the location is known by
    public private(set) var aliases: [String]?
    
    /// URL pointing to the location detail resource
    public private(set) var api_detail_url: NSURL?
    
    /// Date the location was added to Giant Bomb
    public private(set) var date_added: NSDate?
    
    /// Date the location was last updated on Giant Bomb
    public private(set) var date_last_updated: NSDate?
    
    /// Brief summary of the location
    public private(set) var deck: String?
    
    /// Description of the location
    public private(set) var description: String?
    
    /// Game where the location made its first appearance
    public private(set) var first_appeared_in_game: GBGameResource?
    
    /// Unique ID of the location
    public let id: Int?
    
    /// Main image of the location
    public private(set) var image: GBImageURLs?
    
    /// Name of the location
    public private(set) var name: String?
    
    /// URL pointing to the location on Giant Bomb
    public private(set) var site_detail_url: NSURL?
    
    /// Extended info
    public var extendedInfo: GBUnusedExtendedInfo?
    
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
            first_appeared_in_game = GBGameResource(json: firstAppearedInGameJSON)
        } else {
            first_appeared_in_game = nil
        }
        
        if let imageJSON = json["image"] as? [String: AnyObject] {
            image = GBImageURLs(json: imageJSON)
        } else {
            image = nil
        }
        
        name = json["name"] as? String
        site_detail_url = (json["site_detail_url"] as? String)?.url()
    }
    
    public var prettyDescription: String {
        return name ?? "Location \(id)"
    }
}
