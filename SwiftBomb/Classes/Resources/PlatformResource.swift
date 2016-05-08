//
//  PlatformResource.swift
//  Pods
//
//  Created by David Fox on 08/05/2016.
//
//

import Foundation

/**
 A class representing a *Platform* on the Giant Bomb wiki. Examples include *Playstation 4* and *Xbox One*.
 
 To retrieve extended info for a person, call `fetchExtendedInfo(_:)` upon it.
 */
final public class PlatformResource: ResourceUpdating {
    
    /// The resource type.
    public let resourceType = ResourceType.Platform
    
    /// Abbreviation of the platform.
    public private(set) var abbreviation: String?
    
    /// Array of aliases the platform is known by.
    public private(set) var aliases: [String]?
    
    /// URL pointing to the platform detail resource.
    public private(set) var api_detail_url: NSURL?
    
    /// Company that created the platform.
    public private(set) var company: CompanyResource?
    
    /// Date the platform was added to Giant Bomb.
    public private(set) var date_added: NSDate?
    
    /// Date the platform was last updated on Giant Bomb.
    public private(set) var date_last_updated: NSDate?
    
    /// Brief summary of the platform.
    public private(set) var deck: String?
    
    /// Description of the platform.
    public private(set) var description: String?
    
    /// Unique ID of the platform.
    public let id: Int?
    
    /// Main image of the platform.
    public private(set) var image: ImageURLs?
    
    /// Approximate number of sold hardware units.
    public private(set) var install_base: String?
    
    /// Name of the platform.
    public private(set) var name: String?
    
    /// Flag indicating whether the platform has online capabilities.
    public private(set) var online_support: Bool?
    
    /// Initial price point of the platform.
    public private(set) var original_price: String?
    
    /// Date of the platform.
    public private(set) var release_date: NSDate?
    
    /// URL pointing to the platform on Giant Bomb.
    public private(set) var site_detail_url: NSURL?
    
    /// Extended info. Unused for this resource type.
    public var extendedInfo: UnusedExtendedInfo?
    
    /// Used to create a `PlatformResource` from JSON.
    public init(json: [String : AnyObject]) {
        
        id = json["id"] as? Int
        
        update(json)
    }
    
    func update(json: [String : AnyObject]) {
        
        abbreviation = json["abbreviation"] as? String
        aliases = (json["aliases"] as? String)?.newlineSeparatedStrings()
        api_detail_url = (json["api_detail_url"] as? String)?.url()
        
        if let companyJSON = json["company"] as? [String: AnyObject] {
            company = CompanyResource(json: companyJSON)
        }
        
        date_added = (json["date_added"] as? String)?.dateRepresentation()
        date_last_updated = (json["date_last_updated"] as? String)?.dateRepresentation()
        deck = json["deck"] as? String
        description = json["description"] as? String
        
        if let imageJSON = json["image"] as? [String: AnyObject] {
            image = ImageURLs(json: imageJSON)
        }
        
        install_base = json["install_base"] as? String
        name = json["name"] as? String
        online_support = json["online_support"] as? Bool
        original_price = json["original_price"] as? String
        release_date = (json["release_date"] as? String)?.dateRepresentation()
        site_detail_url = (json["site_detail_url"] as? String)?.url()
    }
    
    /// Pretty description of the platform.
    public var prettyDescription: String {
        return name ?? "Platform \(id)"
    }
}