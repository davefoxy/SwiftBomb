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
    
    /// The resource type
    public let resourceType = ResourceType.Character
    
    /// Array of aliases the character is known by.
    public private(set) var aliases: [String]?
    
    /// URL pointing to the character detail resource.
    public private(set) var api_detail_url: NSURL?
    
    /// Birthday of the character
    public private(set) var birthday: NSDate?
    
    /// Date the character was added to Giant Bomb.
    public private(set) var date_added: NSDate?
    
    /// Date the character was last updated on Giant Bomb.
    public private(set) var date_last_updated: NSDate?
    
    /// Brief summary of the character.
    public private(set) var deck: String?
    
    /// Description of the character.
    public private(set) var description: String?
    
    /// Game where the character made its first appearance.
    public private(set) var first_appeared_in_game: GameResource?
    
    /// Gender of the character.
    public private(set) var gender: Gender?
    
    /// Unique ID of the character.
    public let id: Int?
    
    /// Main image of the character.
    public private(set) var image: ImageURLs?
    
    /// Name of the character.
    public private(set) var name: String?
    
    /// Last name of the character.
    public private(set) var last_name: String?
    
    /// Real name of the character.
    public private(set) var real_name: String?
    
    /// URL pointing to the character on Giant Bomb.
    public private(set) var site_detail_url: NSURL?

    /// Extended info
    public var extendedInfo: CharacterExtendedInfo?
    
    /// Used to create a `CharacterResource` from JSON
    public init(json: [String: AnyObject]) {
        
        id = json["id"] as? Int

        update(json)
    }
    
    func update(json: [String : AnyObject]) {
    
        aliases = (json["aliases"] as? String)?.newlineSeparatedStrings()
        api_detail_url = (json["api_detail_url"] as? String)?.url()
        birthday = (json["birthday"] as? String)?.shortDateRepresentation()
        date_added = (json["date_added"] as? String)?.dateRepresentation()
        date_last_updated = (json["date_last_updated"] as? String)?.dateRepresentation()
        deck = json["deck"] as? String
        description = json["description"] as? String
        
        if let firstAppearedInGameJSON = json["first_appeared_in_game"] as? [String: AnyObject] {
            first_appeared_in_game = GameResource(json: firstAppearedInGameJSON)
        } else {
            first_appeared_in_game = nil
        }
        
        name = json["name"] as? String
        last_name = json["last_name"] as? String
        real_name = json["real_name"] as? String
        site_detail_url = (json["site_detail_url"] as? String)?.url()
        
        if let genderInt = json["gender"] as? Int {
            gender = Gender(rawValue: genderInt)!
        } else {
            gender = Gender.Unknown
        }
        
        if let imageJSON = json["image"] as? [String: AnyObject] {
            image = ImageURLs(json: imageJSON)
        } else {
            image = nil
        }
    }
    
    /// Pretty description of the character.
    public var prettyDescription: String {
        return name ?? "Character \(id)"
    }
}

/**
 Struct containing extended information for `CharacterResource`s. To retrieve, call `fetchExtendedInfo(completion: (error: RequestError?)` upon the original resource then access the data on the resource's `extendedInfo` property.
 */
public struct CharacterExtendedInfo: ResourceExtendedInfo {

    /// Concepts related to the character.
    public let concepts: [ConceptResource]
    
    /// Enemeis of the character.
    public let enemies: [CharacterResource]
    
    /// Franchises related to the character.
    public let franchises: [FranchiseResource]
    
    /// Friends of the character.
    public let friends: [CharacterResource]
    
    /// Games the character has appeared in.
    public let games: [GameResource]
    
    /// Locations related to the character.
    public let locations: [LocationResource]
    
    /// Objects related to the character.
    public let objects: [ObjectResource]
    
    /// People who have worked with the character.
    public let people: [PersonResource]
    
    public init(json: [String: AnyObject]) {

        concepts = json.jsonMappedResources("concepts")
        enemies = json.jsonMappedResources("enemies")
        franchises = json.jsonMappedResources("franchises")
        friends = json.jsonMappedResources("friends")
        games = json.jsonMappedResources("games")
        locations = json.jsonMappedResources("locations")
        objects = json.jsonMappedResources("objects")
        people = json.jsonMappedResources("people")
    }
}
