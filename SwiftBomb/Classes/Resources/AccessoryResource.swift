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
    public let resourceType = ResourceType.Accessory
    
    /// Date the accessory was added to Giant Bomb.
    public private(set) var date_added: NSDate?
    
    /// Date the accessory was last updated on Giant Bomb.
    public private(set) var date_last_updated: NSDate?
    
    /// Brief summary of the accessory.
    public private(set) var deck: String?
    
    /// Description of the accessory.
    public private(set) var description: String?
    
    /// Unique ID of the accessory.
    public let id: Int?
    
    /// Main image of the accessory.
    public private(set) var image: ImageURLs?
    
    /// Name of the accessory.
    public private(set) var name: String?
    
    /// URL pointing to the accessory on Giant Bomb.
    public private(set) var site_detail_url: NSURL?
    
    /// URL pointing to the accessory detail resource.
    public private(set) var api_detail_url: NSURL?
    
    /// Extended info. Unused for this resource type.
    public var extendedInfo: UnusedExtendedInfo?
    
    /// Used to create an `AccessoryResource` from JSON.
    public init(json: [String : AnyObject]) {
        
        id = json["id"] as? Int

        update(json)
    }
    
    func update(json: [String : AnyObject]) {
        
        date_added = (json["date_added"] as? String)?.dateRepresentation()
        date_last_updated = (json["date_last_updated"] as? String)?.dateRepresentation()
        deck = json["deck"] as? String
        description = json["description"] as? String
        
        if let imageJSON = json["image"] as? [String: AnyObject] {
            image = ImageURLs(json: imageJSON)
        }
        
        name = json["name"] as? String
        site_detail_url = (json["site_detail_url"] as? String)?.url()
        api_detail_url = (json["api_detail_url"] as? String)?.url()
    }
    
    /// Pretty description of the accessory.
    public var prettyDescription: String {
        return name ?? "Accessory \(id)"
    }
}