//
//  GameResource.swift
//  SwiftBomb
//
//  Created by David Fox on 17/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

/**
 A class representing a *Game* on the Giant Bomb wiki. Examples include *Farcry 3* and *Splatoon*. To retrieve information about a specific *release* of a game, see `GameReleaseResource`.
 
 To retrieve extended info for a game, call `fetchExtendedInfo(_:)` upon it.
 */
final public class GameResource: ResourceUpdating {
    
    /// The resource type.
    public let resourceType = ResourceType.Game
    
    /// Array of aliases the game is known by.
    public private(set) var aliases: [String]?
    
    /// URL pointing to the game detail resource.
    public private(set) var api_detail_url: NSURL?
    
    /// Date the game was added to Giant Bomb.
    public private(set) var date_added: NSDate?
    
    /// Date the game was last updated on Giant Bomb.
    public private(set) var date_last_updated: NSDate?
    
    /// Brief summary of the game.
    public private(set) var deck: String?
    
    /// Description of the game.
    public private(set) var description: String?
    
    /// Expected date the game will be released. Only contains the month and year. Fetch extended info for the full date.
    public private(set) var expected_release_date: NSDate?
    
    /// Unique ID of the game.
    public let id: Int?
    
    /// Main image of the game.
    public private(set) var image: ImageURLs?
    
    /// Name of the game.
    public private(set) var name: String?
    
    /// Number of user reviews of the game on Giant Bomb.
    public private(set) var number_of_user_reviews: Int?
    
    /// Rating of the first release of the game.
    public private(set) var original_game_rating: [(id: Int, name: String)]?
    
    /// Date the game was first released.
    public private(set) var original_release_date: NSDate?
    
    /// The platforms the game exists on.
    public private(set) var platforms: [PlatformResource]?
    
    /// URL pointing to the game on Giant Bomb.
    public private(set) var site_detail_url: NSURL?
    
    /// Extended info.
    public var extendedInfo: GameExtendedInfo?
    
    /// Used to create a `GameResource` from JSON.
    public init(json: [String : AnyObject]) {
        
        id = json["id"] as? Int

        update(json)
    }
    
    func update(json: [String : AnyObject]) {
        
        aliases = (json["aliases"] as? String)?.newlineSeparatedStrings()
        api_detail_url = (json["api_detail_url"] as? String)?.url()
        date_added = (json["date_added"] as? String)?.dateRepresentation()
        date_last_updated = (json["date_last_updated"] as? String)?.dateRepresentation()
        deck = json["deck"] as? String
        description = json["description"] as? String
        
        if let expectedReleaseMonth = json["expected_release_month"] as? Int,
            let expectedReleaseYear = json["expected_release_year"] as? Int {
            let dateComponents = NSDateComponents()
            dateComponents.month = expectedReleaseMonth
            dateComponents.year = expectedReleaseYear
            expected_release_date = NSCalendar.currentCalendar().dateFromComponents(dateComponents)
        }
        
        if let imageJSON = json["image"] as? [String: AnyObject] {
            image = ImageURLs(json: imageJSON)
        } else {
            image = nil
        }
        
        name = json["name"] as? String
        number_of_user_reviews = json["number_of_user_reviews"] as? Int
        original_release_date = (json["original_release_date"] as? String)?.dateRepresentation()
        site_detail_url = (json["site_detail_url"] as? String)?.url()
        
        original_game_rating = (json["original_game_rating"] as? [[String: AnyObject]])?.idNameTupleMaps()
        
        platforms = [PlatformResource]()
        if let platformsJSON = json["platforms"] as? [[String: AnyObject]] {
            
            for platformJSON in platformsJSON {
                if
                    let id = platformJSON["id"] as? Int,
                    let name = platformJSON["name"] as? String,
                    let abbreviation = platformJSON["abbreviation"] as? String {
                    let platform = PlatformResource(id: id, name: name, abbreviation: abbreviation)
                    platforms?.append(platform)
                }
            }
        }
    }
    
    /// Pretty description of the game.
    public var prettyDescription: String {
        return name ?? "Game \(id)"
    }
}

/**
 Struct containing extended information for `GameResource`s. To retrieve, call `fetchExtendedInfo(_:)` upon the original resource then access the data on the resource's `extendedInfo` property.
 */
public struct GameExtendedInfo: ResourceExtendedInfo {
    
    /// Characters related to the game.
    public let characters: [CharacterResource]
    
    /// Concepts related to the game.
    public let concepts: [ConceptResource]
    
    /// Companies who developed the game.
    public let developers: [CompanyResource]
    
    /// Expected date the game will be released. The extended info version of this date also includes the day of release.
    public let expected_release_date: NSDate?
    
    /// Characters that first appeared in the game.
    public let first_appearance_characters: [CharacterResource]
    
    /// Concepts that first appeared in the game.
    public let first_appearance_concepts: [ConceptResource]
    
    /// Locations that first appeared in the game.
    public let first_appearance_locations: [LocationResource]
    
    /// Objects that first appeared in the game.
    public let first_appearance_objects: [ObjectResource]
    
    /// People that were first credited in the game.
    public let first_appearance_people: [PersonResource]
    
    /// Franchises related to the game.
    public let franchises: [FranchiseResource]
    
    /// Genres that encompass the game.
    public let genres: [GenreResource]?
    
    /// List of images associated to the game.
    public let images: [ImageURLs]?
    
    /// Characters killed in the game.
    public let killed_characters: [CharacterResource]
    
    /// Locations related to the game.
    public let locations: [LocationResource]
    
    /// Objects related to the game.
    public let objects: [ObjectResource]
    
    /// Rating of the first release of the game.
    public let original_game_rating: [(id: Int, name: String)]?
    
    /// People who have worked with the game.
    public let people: [PersonResource]
    
    /// Companies who published the game.
    public let publishers: [CompanyResource]
    
    /// Releases of the game.
    public let releases: [GameReleaseResource]?
    
    /// Staff reviews of the game.
    public let reviews: [StaffReviewResource]?
    
    /// Other games similar to the game.
    public let similar_games: [GameResource]
    
    /// Themes that encompass the game.
    public let themes: [(id: Int, name: String)]?
    
    /// Videos associated to the game.
    public let videos: [VideoURLs]?
    
    /// Used to create a `GameExtendedInfo` from JSON.
    public init(json: [String : AnyObject]) {
        
        characters = json.jsonMappedResources("characters")
        concepts = json.jsonMappedResources("concepts")
        developers = json.jsonMappedResources("developers")
        first_appearance_characters = json.jsonMappedResources("first_appearance_characters")
        first_appearance_concepts = json.jsonMappedResources("first_appearance_concepts")
        first_appearance_locations = json.jsonMappedResources("first_appearance_locations")
        first_appearance_objects = json.jsonMappedResources("first_appearance_objects")
        first_appearance_people = json.jsonMappedResources("first_appearance_people")
        franchises = json.jsonMappedResources("franchises")
        genres = json.jsonMappedResources("genres")
        
        images = [ImageURLs]()
        if let imagesJSON = json["images"] as? [[String: AnyObject]] {
            
            for imageJSON in imagesJSON {
                let image = ImageURLs(json: imageJSON)
                images?.append(image)
            }
        }
        
        killed_characters = json.jsonMappedResources("killed_characters")
        locations = json.jsonMappedResources("locations")
        objects = json.jsonMappedResources("objects")
        original_game_rating = (json["original_game_rating"] as? [[String: AnyObject]])?.idNameTupleMaps()
        people = json.jsonMappedResources("people")
        
        publishers = json.jsonMappedResources("publishers")
        releases = json.jsonMappedResources("releases")
        reviews = json.jsonMappedResources("reviews")
        similar_games = json.jsonMappedResources("similar_games")
        themes = (json["themes"] as? [[String: AnyObject]])?.idNameTupleMaps()
        
        videos = [VideoURLs]()
        if let videosJSON = json["videos"] as? [[String: AnyObject]] {
            
            for videoJSON in videosJSON {
                let video = VideoURLs(json: videoJSON)
                videos?.append(video)
            }
        }
        
        if let expectedReleaseDay = json["expected_release_day"] as? Int,
            let expectedReleaseMonth = json["expected_release_month"] as? Int,
            let expectedReleaseYear = json["expected_release_year"] as? Int {
            let dateComponents = NSDateComponents()
            dateComponents.day = expectedReleaseDay
            dateComponents.month = expectedReleaseMonth
            dateComponents.year = expectedReleaseYear
            expected_release_date = NSCalendar.currentCalendar().dateFromComponents(dateComponents)
        } else {
            expected_release_date = nil
        }
        
    }
}