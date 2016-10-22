//
//  PersonResource.swift
//  SwiftBomb
//
//  Created by David Fox on 22/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

/**
 A class representing a *Person* on the Giant Bomb wiki. Examples include *Jeff Gerstmann* and *Hideo Kojima*. These are typically real people as apposed to `Character` which represents fictional people or, in some cases, real people who appear as themselves in games.
 
 To retrieve extended info for a person, call `fetchExtendedInfo(_:)` upon it.
 */
final public class PersonResource: ResourceUpdating {
    
    /// The resource type.
    public let resourceType = ResourceType.Person

    /// Array of aliases the person is known by.
    public fileprivate(set) var aliases: [String]?
    
    /// URL pointing to the person detail resource.
    public fileprivate(set) var api_detail_url: URL?
    
    /// Date the person was born.
    public fileprivate(set) var birth_date: Date?
    
    /// Country the person resides in.
    public fileprivate(set) var country: String?
    
    /// Date the person was added to Giant Bomb.
    public fileprivate(set) var date_added: Date?
    
    /// Date the person was last updated on Giant Bomb.
    public fileprivate(set) var date_last_updated: Date?
    
    /// Date the person died.
    public fileprivate(set) var death_date: Date?
    
    /// Brief summary of the person.
    public fileprivate(set) var deck: String?
    
    /// Description of the person.
    public fileprivate(set) var description: String?
    
    /// Game the person was first credited.
    public fileprivate(set) var first_credited_game: GameResource?
    
    /// Gender of the person.
    public fileprivate(set) var gender: Gender?
    
    /// City or town the person resides in.
    public fileprivate(set) var hometown: String?
    
    /// Unique ID of the person.
    public let id: Int?
    
    /// Main image of the person.
    public fileprivate(set) var image: ImageURLs?
    
    /// Name of the person.
    public fileprivate(set) var name: String?
    
    /// URL pointing to the person on Giant Bomb.
    public fileprivate(set) var site_detail_url: URL?
    
    /// Extended info.
    public var extendedInfo: PersonExtendedInfo?
    
    /// Used to create a `PersonResource` from JSON.
    public init(json: [String : AnyObject]) {
        
        id = json["id"] as? Int

        update(json: json)
    }
    
    func update(json: [String : AnyObject]) {
        
        aliases = (json["aliases"] as? String)?.newlineSeparatedStrings() ?? aliases
        api_detail_url = (json["api_detail_url"] as? String)?.url() as URL?? ?? api_detail_url
        birth_date = (json["birth_date"] as? String)?.shortDateRepresentation() as Date?? ?? birth_date
        country = json["country"] as? String ?? country
        date_added = (json["date_added"] as? String)?.dateRepresentation() as Date?? ?? date_added
        date_last_updated = (json["date_last_updated"] as? String)?.dateRepresentation() as Date?? ?? date_last_updated
        death_date = (json["death_date"] as? String)?.shortDateRepresentation() as Date?? ?? death_date
        deck = json["deck"] as? String ?? deck
        description = json["description"] as? String ?? description
        
        if let firstCreditedGameJSON = json["first_credited_game"] as? [String: AnyObject] {
            first_credited_game = GameResource(json: firstCreditedGameJSON)
        }
        
        if let genderInt = json["gender"] as? Int {
            gender = Gender(rawValue: genderInt)!
        } else {
            gender = Gender.unknown
        }
        
        hometown = json["hometown"] as? String ?? hometown
        if let imageJSON = json["image"] as? [String: AnyObject] {
            image = ImageURLs(json: imageJSON)
        }
        
        name = json["name"] as? String ?? name
        site_detail_url = (json["site_detail_url"] as? String)?.url() as URL?? ?? site_detail_url
    }
    
    /// Pretty description of the person.
    public var prettyDescription: String {
        return name ?? "Person \(id)"
    }
}

/**
 Struct containing extended information for `PersonResource`s. To retrieve, call `fetchExtendedInfo(_:)` upon the original resource then access the data on the resource's `extendedInfo` property.
 */
public struct PersonExtendedInfo: ResourceExtendedInfo {
    
    /// Characters related to the person.
    public fileprivate(set) var characters: [CharacterResource]?
    
    /// Concepts related to the person.
    public fileprivate(set) var concepts: [ConceptResource]?
    
    /// Franchises related to the person.
    public fileprivate(set) var franchises: [FranchiseResource]?
    
    /// Games the person has appeared in.
    public fileprivate(set) var games: [GameResource]?
    
    /// Locations related to the person.
    public fileprivate(set) var locations: [LocationResource]?
    
    /// Objects related to the person.
    public fileprivate(set) var objects: [ObjectResource]?
    
    /// People who have worked with the person.
    public fileprivate(set) var people: [PersonResource]?
    
    /// Used to create a `PersonExtendedInfo` from JSON.
    public init(json: [String : AnyObject]) {
        
        update(json)
    }
    
    /// A method used for updating structs. Usually after further requests for more field data.
    public mutating func update(_ json: [String : AnyObject]) {
        
        characters = json.jsonMappedResources("characters") ?? characters
        concepts = json.jsonMappedResources("concepts") ?? concepts
        franchises = json.jsonMappedResources("franchises") ?? franchises
        games = json.jsonMappedResources("games") ?? games
        locations = json.jsonMappedResources("locations") ?? locations
        objects = json.jsonMappedResources("objects") ?? objects
        people = json.jsonMappedResources("people") ?? people
    }
}
