//
//  CompanyResource.swift
//  SwiftBomb
//
//  Created by David Fox on 16/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

/**
 A class representing a *Company* on the Giant Bomb wiki. Examples include *Square Enix* and *Sony Computer Entertainment*. 
 
 To retrieve extended info for a company, call `fetchExtendedInfo(_:)` upon it.
 */
final public class CompanyResource: ResourceUpdating {
    
    /// The resource type.
    public let resourceType = ResourceType.Company
    
    /// Abbreviation of the company.
    public private(set) var abbreviation: String?
    
    /// Array of aliases the company is known by.
    public private(set) var aliases: [String]?
    
    /// URL pointing to the company detail resource.
    public private(set) var api_detail_url: NSURL?
    
    /// Date the company was added to Giant Bomb.
    public private(set) var date_added: NSDate?
    
    /// Date the company was founded.
    public private(set) var date_founded: NSDate?
    
    /// Date the company was last updated on Giant Bomb.
    public private(set) var date_last_updated: NSDate?
    
    /// Brief summary of the company.
    public private(set) var deck: String?
    
    /// Description of the company.
    public private(set) var description: String?
    
    /// Unique ID of the company.
    public let id: Int?
    
    /// Main image of the company.
    public private(set) var image: ImageURLs?
    
    /// Street address of the company.
    public private(set) var location_address: String?
    
    /// City the company resides in.
    public private(set) var location_city: String?
    
    /// Country the company resides in.
    public private(set) var location_country: String?
    
    /// State the company resides in.
    public private(set) var location_state: String?
    
    /// Name of the company.
    public private(set) var name: String?
    
    /// Phone number of the company.
    public private(set) var phone: String?
    
    /// URL pointing to the company on Giant Bomb.
    public private(set) var site_detail_url: NSURL?
    
    /// URL to the company website.
    public private(set) var website: NSURL?
    
    /// Extended info.
    public var extendedInfo: CompanyExtendedInfo?

    /// Used to create a `CompanyResource` from JSON.
    public init(json: [String: AnyObject]) {
        
        id = json["id"] as? Int

        update(json)
    }
    
    func update(json: [String : AnyObject]) {
        
        aliases = (json["aliases"] as? String)?.newlineSeparatedStrings() ?? aliases
        abbreviation = json["abbreviation"] as? String ?? abbreviation
        api_detail_url = (json["api_detail_url"] as? String)?.url() ?? api_detail_url
        date_added = (json["date_added"] as? String)?.dateRepresentation() ?? date_added
        date_founded = (json["date_founded"] as? String)?.dateRepresentation() ?? date_founded
        date_last_updated = (json["date_last_updated"] as? String)?.dateRepresentation() ?? date_last_updated
        deck = json["deck"] as? String ?? deck
        description = json["description"] as? String ?? description
        location_address = json["location_address"] as? String ?? location_address
        location_city = json["location_city"] as? String ?? location_city
        location_state = json["location_state"] as? String ?? location_state
        location_country = json["location_country"] as? String ?? location_country
        name = json["name"] as? String ?? name
        phone = json["phone"] as? String ?? phone
        site_detail_url = (json["site_detail_url"] as? String)?.url() ?? site_detail_url
        website = (json["website"] as? String)?.url() ?? website
        
        if let imageJSON = json["image"] as? [String: AnyObject] {
            image = ImageURLs(json: imageJSON)
        }
    }
    
    /// Pretty description of the company.
    public var prettyDescription: String {
        return name ?? "Company \(id)"
    }
}

/**
 Struct containing extended information for `CompanyResource`s. To retrieve, call `fetchExtendedInfo(_:)` upon the original resource then access the data on the resource's `extendedInfo` property.
 */
public struct CompanyExtendedInfo: ResourceExtendedInfo {
    
    /// Characters related to the company.
    public private(set) var characters: [CharacterResource]?
    
    /// Concepts related to the company.
    public private(set) var concepts: [ConceptResource]?
    
    /// Games the company has developed.
    public private(set) var developed_games: [GameResource]?
    
    /// Releases the company has developed.
    public private(set) var developer_releases: [GameReleaseResource]?
    
    /// Releases the company has distributed.
    public private(set) var distributor_releases: [GameReleaseResource]?
    
    /// Locations related to the company.
    public private(set) var locations: [LocationResource]?
    
    /// Objects related to the company.
    public private(set) var objects: [ObjectResource]?
    
    /// People who have worked with the company.
    public private(set) var people: [PersonResource]?
    
    /// Games published by the company.
    public private(set) var published_games: [GameResource]?
    
    /// Releases the company has published.
    public private(set) var publisher_releases: [GameReleaseResource]?
    
    /// Used to create a `CompanyExtendedInfo` from JSON.
    public init(json: [String : AnyObject]) {
        
        update(json)
    }
    
    /// A method used for updating structs. Usually after further requests for more field data.
    public mutating func update(json: [String : AnyObject]) {
        
        characters = json.jsonMappedResources("characters") ?? characters
        concepts = json.jsonMappedResources("concepts") ?? concepts
        developed_games = json.jsonMappedResources("developed_games") ?? developed_games
        developer_releases = json.jsonMappedResources("developer_releases") ?? developer_releases
        distributor_releases = json.jsonMappedResources("distributor_releases") ?? distributor_releases
        locations = json.jsonMappedResources("locations") ?? locations
        objects = json.jsonMappedResources("objects") ?? objects
        people = json.jsonMappedResources("people") ?? people
        published_games = json.jsonMappedResources("published_games") ?? published_games
        publisher_releases = json.jsonMappedResources("publisher_releases") ?? publisher_releases
    }
}