//
//  GBPersonResource.swift
//  GBAPI
//
//  Created by David Fox on 22/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

final public class GBPersonResource: GBResourceUpdating {
    
    /// The resource type
    public let resourceType = ResourceType.Person

    /// Array of aliases the person is known by
    public private(set) var aliases: [String]?
    
    /// URL pointing to the person detail resource
    public private(set) var api_detail_url: NSURL?
    
    /// Date the person was born
    public private(set) var birth_date: NSDate?
    
    /// Country the person resides in
    public private(set) var country: String?
    
    /// Date the person was added to Giant Bomb
    public private(set) var date_added: NSDate?
    
    /// Date the person was last updated on Giant Bomb
    public private(set) var date_last_updated: NSDate?
    
    /// Date the person died
    public private(set) var death_date: NSDate?
    
    /// Brief summary of the person
    public private(set) var deck: String?
    
    /// Description of the person
    public private(set) var description: String?
    
    /// Game the person was first credited
    public private(set) var first_credited_game: GBGameResource?
    
    /// Gender of the person. Available options are: Male, Female, Other
    public private(set) var gender: Gender?
    
    /// City or town the person resides in
    public private(set) var hometown: String?
    
    /// Unique ID of the person
    public let id: Int?
    
    /// Main image of the person
    public private(set) var image: GBImageURLs?
    
    /// Name of the person.
    public private(set) var name: String?
    
    /// URL pointing to the person on Giant Bomb
    public private(set) var site_detail_url: NSURL?
    
    /// Extended info
    public var extendedInfo: GBPersonExtendedInfo?
    
    public init(json: [String : AnyObject]) {
        
        id = json["id"] as? Int

        update(json)
    }
    
    func update(json: [String : AnyObject]) {
        
        aliases = (json["aliases"] as? String)?.newlineSeparatedStrings()
        api_detail_url = (json["api_detail_url"] as? String)?.url()
        birth_date = (json["birthday_date"] as? String)?.shortDateRepresentation()
        country = json["country"] as? String
        date_added = (json["date_added"] as? String)?.dateRepresentation()
        date_last_updated = (json["date_last_updated"] as? String)?.dateRepresentation()
        death_date = (json["death_date"] as? String)?.shortDateRepresentation()
        deck = json["deck"] as? String
        description = json["description"] as? String
        
        if let firstCreditedGameJSON = json["first_credited_game"] as? [String: AnyObject] {
            first_credited_game = GBGameResource(json: firstCreditedGameJSON)
        } else {
            first_credited_game = nil
        }
        
        if let genderInt = json["gender"] as? Int {
            gender = Gender(rawValue: genderInt)!
        } else {
            gender = Gender.Unknown
        }
        
        hometown = json["hometown"] as? String
        if let imageJSON = json["image"] as? [String: AnyObject] {
            image = GBImageURLs(json: imageJSON)
        } else {
            image = nil
        }
        
        name = json["name"] as? String
        site_detail_url = (json["site_detail_url"] as? String)?.url()
    }
    
    public var prettyDescription: String {
        return name ?? "Person \(id)"
    }
}

public struct GBPersonExtendedInfo: GBResourceExtendedInfo {
    
    /// Characters related to the person
    public let characters: [GBCharacterResource]
    
    /// Concepts related to the person
    public let concepts: [GBConceptResource]
    
    /// Franchises related to the person
    public let franchises: [GBFranchiseResource]
    
    /// Games the person has appeared in
    public let games: [GBGameResource]
    
    /// Locations related to the person
    public let locations: [GBLocationResource]
    
    /// Objects related to the person
    public let objects: [GBObjectResource]
    
    /// People who have worked with the person
    public let people: [GBPersonResource]
    
    public init(json: [String : AnyObject]) {
        
        characters = json.jsonMappedResources("characters")
        concepts = json.jsonMappedResources("concepts")
        franchises = json.jsonMappedResources("franchises")
        games = json.jsonMappedResources("games")
        locations = json.jsonMappedResources("locations")
        objects = json.jsonMappedResources("objects")
        people = json.jsonMappedResources("people")
    }
}