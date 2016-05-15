//
//  GenreResource.swift
//  SwiftBomb
//
//  Created by David Fox on 25/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

/**
 A class representing a *Genre* on the Giant Bomb wiki. Examples include *Adventure* and *RPG*.
 
 To retrieve extended info for a genre, call `fetchExtendedInfo(_:)` upon it.
 */
final public class GenreResource: ResourceUpdating {
    
    /// The resource type.
    public let resourceType = ResourceType.Genre
    
    /// URL pointing to the genre detail resource.
    public private(set) var api_detail_url: NSURL?
    
    /// Date the genre was added to Giant Bomb.
    public private(set) var date_added: NSDate?
    
    /// Date the genre was last updated on Giant Bomb.
    public private(set) var date_last_updated: NSDate?
    
    /// Brief summary of the genre.
    public private(set) var deck: String?
    
    /// Description of the genre.
    public private(set) var description: String?
    
    /// Unique ID of the genre.
    public let id: Int?
    
    /// Main image of the genre.
    public private(set) var image: ImageURLs?
    
    /// Name of the genre.
    public private(set) var name: String?
    
    /// URL pointing to the genre on Giant Bomb.
    public private(set) var site_detail_url: NSURL?
    
    /// Extended info. Unused for this resource type.
    public var extendedInfo: UnusedExtendedInfo?
    
    /// Used to create a `GenreResource` from JSON.
    public init(json: [String : AnyObject]) {
        
        id = json["id"] as? Int

        update(json)
    }
    
    func update(json: [String : AnyObject]) {
        
        api_detail_url = (json["api_detail_url"] as? String)?.url() ?? api_detail_url
        date_added = (json["date_added"] as? String)?.dateRepresentation() ?? date_added
        date_last_updated = (json["date_last_updated"] as? String)?.dateRepresentation() ?? date_last_updated
        deck = json["deck"] as? String ?? deck
        description = json["description"] as? String ?? description
        
        if let imageJSON = json["image"] as? [String: AnyObject] {
            image = ImageURLs(json: imageJSON)
        }
        
        name = json["name"] as? String ?? name
        site_detail_url = (json["site_detail_url"] as? String)?.url() ?? site_detail_url
    }
    
    /// Pretty description of the genre.
    public var prettyDescription: String {
        return name ?? "Genre \(id)"
    }
}
