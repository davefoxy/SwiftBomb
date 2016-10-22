//
//  AccessoryResource.swift
//  SwiftBomb
//
//  Created by David Fox on 25/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

/**
 A class representing an *Accessory* on the Giant Bomb wiki. Examples include controllers and VR headsets.
 
 To retrieve extended info for an accessory, call `fetchExtendedInfo(_:)` upon it.
*/
final public class AccessoryResource: ResourceUpdating {
    
    /// The resource type.
    public let resourceType = ResourceType.accessory
    
    /// Date the accessory was added to Giant Bomb.
    public fileprivate(set) var date_added: Date?
    
    /// Date the accessory was last updated on Giant Bomb.
    public fileprivate(set) var date_last_updated: Date?
    
    /// Brief summary of the accessory.
    public fileprivate(set) var deck: String?
    
    /// Description of the accessory.
    public fileprivate(set) var description: String?
    
    /// Unique ID of the accessory.
    public let id: Int?
    
    /// Main image of the accessory.
    public fileprivate(set) var image: ImageURLs?
    
    /// Name of the accessory.
    public fileprivate(set) var name: String?
    
    /// URL pointing to the accessory on Giant Bomb.
    public fileprivate(set) var site_detail_url: URL?
    
    /// URL pointing to the accessory detail resource.
    public fileprivate(set) var api_detail_url: URL?
    
    /// Extended info. Unused for this resource type.
    public var extendedInfo: UnusedExtendedInfo?
    
    /// Used to create an `AccessoryResource` from JSON.
    public init(json: [String : AnyObject]) {
        
        id = json["id"] as? Int

        update(json: json)
    }
    
    /// A method used for updating structs. Usually after further requests for more field data.
    func update(json: [String : AnyObject]) {
        
        date_added = (json["date_added"] as? String)?.dateRepresentation() as Date?? ?? date_added
        date_last_updated = (json["date_last_updated"] as? String)?.dateRepresentation() as Date?? ?? date_last_updated
        deck = json["deck"] as? String ?? deck
        description = json["description"] as? String ?? description
        
        if let imageJSON = json["image"] as? [String: AnyObject] {
            image = ImageURLs(json: imageJSON)
        }
        
        name = json["name"] as? String ?? name
        site_detail_url = (json["site_detail_url"] as? String)?.url() as URL?? ?? site_detail_url
        api_detail_url = (json["api_detail_url"] as? String)?.url() as URL?? ?? api_detail_url
    }
    
    /// Pretty description of the accessory.
    public var prettyDescription: String {
        return name ?? "Accessory \(id)"
    }
}
