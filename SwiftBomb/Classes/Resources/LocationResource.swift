//
//  LocationResource.swift
//  SwiftBomb
//
//  Created by David Fox on 25/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

/**
 A class representing a *Location* on the Giant Bomb wiki. Examples include *The Moon* and *Underwater*.
 
 To retrieve extended info for a location, call `fetchExtendedInfo(_:)` upon it.
 */
final public class LocationResource: ResourceUpdating {
    
    /// The resource type.
    public let resourceType = ResourceType.location
    
    /// An array of aliases the location is known by.
    public fileprivate(set) var aliases: [String]?
    
    /// URL pointing to the location detail resource.
    public fileprivate(set) var api_detail_url: URL?
    
    /// Date the location was added to Giant Bomb.
    public fileprivate(set) var date_added: Date?
    
    /// Date the location was last updated on Giant Bomb.
    public fileprivate(set) var date_last_updated: Date?
    
    /// Brief summary of the location.
    public fileprivate(set) var deck: String?
    
    /// Description of the location.
    public fileprivate(set) var description: String?
    
    /// Game where the location made its first appearance.
    public fileprivate(set) var first_appeared_in_game: GameResource?
    
    /// Unique ID of the location.
    public let id: Int?
    
    /// Main image of the location.
    public fileprivate(set) var image: ImageURLs?
    
    /// Name of the location.
    public fileprivate(set) var name: String?
    
    /// URL pointing to the location on Giant Bomb.
    public fileprivate(set) var site_detail_url: URL?
    
    /// Extended info. Unused for this resource type.
    public var extendedInfo: UnusedExtendedInfo?
    
    /// Used to create a `LocationResource` from JSON.
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
    
    /// Pretty description of the location.
    public var prettyDescription: String {
        return name ?? "Location \(id)"
    }
}
