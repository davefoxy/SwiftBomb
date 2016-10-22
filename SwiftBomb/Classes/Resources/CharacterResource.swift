//
//  CharacterResource.swift
//  SwiftBomb
//
//  Created by David Fox on 16/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

/**
 A class representing a *Character* on the Giant Bomb wiki. Examples include *Solid Snake* and *Mario*. 
 
 To retrieve extended info for a character, call `fetchExtendedInfo(_:)` upon it.
 */
final public class CharacterResource: ResourceUpdating {
    
    /// The resource type.
    public let resourceType = ResourceType.character
    
    /// Array of aliases the character is known by.
    public fileprivate(set) var aliases: [String]?
    
    /// URL pointing to the character detail resource.
    public fileprivate(set) var api_detail_url: URL?
    
    /// Birthday of the character.
    public fileprivate(set) var birthday: Date?
    
    /// Date the character was added to Giant Bomb.
    public fileprivate(set) var date_added: Date?
    
    /// Date the character was last updated on Giant Bomb.
    public fileprivate(set) var date_last_updated: Date?
    
    /// Brief summary of the character.
    public fileprivate(set) var deck: String?
    
    /// Description of the character.
    public fileprivate(set) var description: String?
    
    /// Game where the character made its first appearance.
    public fileprivate(set) var first_appeared_in_game: GameResource?
    
    /// Gender of the character.
    public fileprivate(set) var gender: Gender?
    
    /// Unique ID of the character.
    public let id: Int?
    
    /// Main image of the character.
    public fileprivate(set) var image: ImageURLs?
    
    /// Name of the character.
    public fileprivate(set) var name: String?
    
    /// Last name of the character.
    public fileprivate(set) var last_name: String?
    
    /// Real name of the character.
    public fileprivate(set) var real_name: String?
    
    /// URL pointing to the character on Giant Bomb.
    public fileprivate(set) var site_detail_url: URL?

    /// Extended info.
    public var extendedInfo: CharacterExtendedInfo?
    
    /// Used to create a `CharacterResource` from JSON.
    public init(json: [String: AnyObject]) {
        
        id = json["id"] as? Int

        update(json: json)
    }
    
    func update(json: [String : AnyObject]) {
    
        aliases = (json["aliases"] as? String)?.newlineSeparatedStrings() ?? aliases
        api_detail_url = (json["api_detail_url"] as? String)?.url() as URL?? ?? api_detail_url
        birthday = (json["birthday"] as? String)?.shortDateRepresentation() as Date?? ?? birthday
        date_added = (json["date_added"] as? String)?.dateRepresentation() as Date?? ?? date_added
        date_last_updated = (json["date_last_updated"] as? String)?.dateRepresentation() as Date?? ?? date_last_updated
        deck = json["deck"] as? String ?? deck
        description = json["description"] as? String ?? description
        
        if let firstAppearedInGameJSON = json["first_appeared_in_game"] as? [String: AnyObject] {
            first_appeared_in_game = GameResource(json: firstAppearedInGameJSON)
        }
        
        name = json["name"] as? String ?? name
        last_name = json["last_name"] as? String ?? last_name
        real_name = json["real_name"] as? String ?? real_name
        site_detail_url = (json["site_detail_url"] as? String)?.url() as URL?? ?? site_detail_url
        
        if let genderInt = json["gender"] as? Int {
            gender = Gender(rawValue: genderInt)!
        } else {
            gender = Gender.unknown
        }
        
        if let imageJSON = json["image"] as? [String: AnyObject] {
            image = ImageURLs(json: imageJSON)
        }
    }
    
    /// Pretty description of the character.
    public var prettyDescription: String {
        return name ?? "Character \(id)"
    }
}

/**
 Struct containing extended information for `CharacterResource`s. To retrieve, call `fetchExtendedInfo(_:)` upon the original resource then access the data on the resource's `extendedInfo` property.
 */
public struct CharacterExtendedInfo: ResourceExtendedInfo {
    
    /// Concepts related to the character.
    public fileprivate(set) var concepts: [ConceptResource]?
    
    /// Enemies of the character.
    public fileprivate(set) var enemies: [CharacterResource]?
    
    /// Franchises related to the character.
    public fileprivate(set) var franchises: [FranchiseResource]?
    
    /// Friends of the character.
    public fileprivate(set) var friends: [CharacterResource]?
    
    /// Games the character has appeared in.
    public fileprivate(set) var games: [GameResource]?
    
    /// Locations related to the character.
    public fileprivate(set) var locations: [LocationResource]?
    
    /// Objects related to the character.
    public fileprivate(set) var objects: [ObjectResource]?
    
    /// People who have worked with the character.
    public fileprivate(set) var people: [PersonResource]?
    
    /// Used to create a `CharacterExtendedInfo` from JSON.
    public init(json: [String: AnyObject]) {
        
        update(json)
    }
    
    /// A method used for updating structs. Usually after further requests for more field data.
    mutating public func update(_ json: [String: AnyObject]) {
        
        concepts = json.jsonMappedResources("concepts") ?? concepts
        enemies = json.jsonMappedResources("enemies") ?? enemies
        franchises = json.jsonMappedResources("franchises") ?? franchises
        friends = json.jsonMappedResources("friends") ?? friends
        games = json.jsonMappedResources("games") ?? games
        locations = json.jsonMappedResources("locations") ?? locations
        objects = json.jsonMappedResources("objects") ?? objects
        people = json.jsonMappedResources("people") ?? people
    }
}
