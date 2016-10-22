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
    public fileprivate(set) var api_detail_url: URL?
    
    /// Date the genre was added to Giant Bomb.
    public fileprivate(set) var date_added: Date?
    
    /// Date the genre was last updated on Giant Bomb.
    public fileprivate(set) var date_last_updated: Date?
    
    /// Brief summary of the genre.
    public fileprivate(set) var deck: String?
    
    /// Description of the genre.
    public fileprivate(set) var description: String?
    
    /// Unique ID of the genre.
    public let id: Int?
    
    /// Main image of the genre.
    public fileprivate(set) var image: ImageURLs?
    
    /// Name of the genre.
    public fileprivate(set) var name: String?
    
    /// URL pointing to the genre on Giant Bomb.
    public fileprivate(set) var site_detail_url: URL?
    
    /// Extended info. Unused for this resource type.
    public var extendedInfo: UnusedExtendedInfo?
    
    /// Used to create a `GenreResource` from JSON.
    public init(json: [String : AnyObject]) {
        
        id = json["id"] as? Int

        update(json: json)
    }
    
    func update(json: [String : AnyObject]) {
        
        api_detail_url = (json["api_detail_url"] as? String)?.url() as URL?? ?? api_detail_url
        date_added = (json["date_added"] as? String)?.dateRepresentation() as Date?? ?? date_added
        date_last_updated = (json["date_last_updated"] as? String)?.dateRepresentation() as Date?? ?? date_last_updated
        deck = json["deck"] as? String ?? deck
        description = json["description"] as? String ?? description
        
        if let imageJSON = json["image"] as? [String: AnyObject] {
            image = ImageURLs(json: imageJSON)
        }
        
        name = json["name"] as? String ?? name
        site_detail_url = (json["site_detail_url"] as? String)?.url() as URL?? ?? site_detail_url
    }
    
    /// Pretty description of the genre.
    public var prettyDescription: String {
        return name ?? "Genre \(id)"
    }
}
