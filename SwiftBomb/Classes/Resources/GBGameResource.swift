//
//  GBGameResource.swift
//  GBAPI
//
//  Created by David Fox on 17/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

final public class GBGameResource: GBResourceUpdating {
    
    /// The resource type
    public let resourceType = ResourceType.Game
    
    /// Array of aliases the game is known by
    public private(set) var aliases: [String]?
    
    /// URL pointing to the game detail resource
    public private(set) var api_detail_url: NSURL?
    
    /// Date the game was added to Giant Bomb
    public private(set) var date_added: NSDate?
    
    /// Date the game was last updated on Giant Bomb
    public private(set) var date_last_updated: NSDate?
    
    /// Brief summary of the game
    public private(set) var deck: String?
    
    /// Description of the game
    public private(set) var description: String?
    
    /// Expected date the game will be released. Only contains the month and year. Fetch extended info for the full date
    public private(set) var expected_release_date: NSDate?
    
    /// Unique ID of the game
    public let id: Int?
    
    /// Main image of the game
    public private(set) var image: GBImage?
    
    /// Name of the game
    public private(set) var name: String?
    
    /// Number of user reviews of the game on Giant Bomb
    public private(set) var number_of_user_reviews: Int?
    
    /// Rating of the first release of the game
    public private(set) var original_game_rating: [(id: Int, name: String)]?
    
    /// Date the game was first released
    public private(set) var original_release_date: NSDate?
    
    /// The platforms the game exists on
    public private(set) var platforms: [GBPlatformResource]?
    
    /// URL pointing to the game on Giant Bomb
    public private(set) var site_detail_url: NSURL?
    
    /// Extended info
    public var extendedInfo: GBGameExtendedInfo?
    
    public init(json: [String : AnyObject]) {
        
        id = json["id"] as? Int

        update(json)
    }
    
    func update(json: [String : AnyObject]) {
        
        if let aliasesString = json["aliases"] as? String {
            aliases = aliasesString.componentsSeparatedByString("\n")
        } else {
            aliases = [String]()
        }
        
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
            image = GBImage(json: imageJSON)
        } else {
            image = nil
        }
        
        name = json["name"] as? String
        number_of_user_reviews = json["number_of_user_reviews"] as? Int
        original_release_date = (json["original_release_date"] as? String)?.dateRepresentation()
        site_detail_url = (json["site_detail_url"] as? String)?.url()
        
        original_game_rating = (json["original_game_rating"] as? [[String: AnyObject]])?.idNameTupleMaps()
        
        platforms = [GBPlatformResource]()
        if let platformsJSON = json["platforms"] as? [[String: AnyObject]] {
            
            for platformJSON in platformsJSON {
                if
                    let id = platformJSON["id"] as? Int,
                    let name = platformJSON["name"] as? String,
                    let abbreviation = platformJSON["abbreviation"] as? String {
                    let platform = GBPlatformResource(id: id, name: name, abbreviation: abbreviation)
                    platforms?.append(platform)
                }
            }
        }
    }
    
    public var prettyDescription: String {
        return name ?? "Game \(id)"
    }
}

public struct GBGameExtendedInfo: GBResourceExtendedInfo {
    
    /// Characters related to the game
    public let characters: [GBCharacterResource]
    
    /// Concepts related to the game
    public let concepts: [GBConceptResource]
    
    /// Companies who developed the game
    public let developers: [GBCompanyResource]
    
    /// Expected day the game will be released. The extended info version of this date also includes the day of release
    public let expected_release_date: NSDate?
    
    /// Characters that first appeared in the game
    public let first_appearance_characters: [GBCharacterResource]
    
    /// Concepts that first appeared in the game
    public let first_appearance_concepts: [GBConceptResource]
    
    /// Locations that first appeared in the game
    public let first_appearance_locations: [GBLocationResource]
    
    /// Objects that first appeared in the game
    public let first_appearance_objects: [GBObjectResource]
    
    /// People that were first credited in the game
    public let first_appearance_people: [GBPersonResource]
    
    /// Franchises related to the game
    public let franchises: [GBFranchiseResource]
    
    /// Genres that encompass the game
    public let genres: [GBGenreResource]?
    
    /// List of images associated to the game
    public let images: [GBImage]?
    
    /// Characters killed in the game
    public let killed_characters: [GBCharacterResource]
    
    /// Locations related to the game
    public let locations: [GBLocationResource]
    
    /// Objects related to the game
    public let objects: [GBObjectResource]
    
    /// Rating of the first release of the game
    public let original_game_rating: [(id: Int, name: String)]?
    
    /// People who have worked with the game
    public let people: [GBPersonResource]
    
    /// Companies who published the game
    public let publishers: [GBCompanyResource]
    
    /// Releases of the game
    public let releases: [GBGameReleaseResource]?
    
    /// Staff reviews of the game (Extended info)
    public let reviews: [(id: Int, name: String)]?
    
    /// Other games similar to the game (Extended info)
    public let similar_games: [GBGameResource]
    
    /// Themes that encompass the game (Extended info)
    public let themes: [(id: Int, name: String)]?
    
    /// Videos associated to the game (Extended info)
    public let videos: [GBVideo]?
    
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
        
        images = [GBImage]()
        if let imagesJSON = json["images"] as? [[String: AnyObject]] {
            
            for imageJSON in imagesJSON {
                let image = GBImage(json: imageJSON)
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
        reviews = (json["reviews"] as? [[String: AnyObject]])?.idNameTupleMaps()
        similar_games = json.jsonMappedResources("similar_games")
        themes = (json["themes"] as? [[String: AnyObject]])?.idNameTupleMaps()
        
        videos = [GBVideo]()
        if let videosJSON = json["videos"] as? [[String: AnyObject]] {
            
            for videoJSON in videosJSON {
                let video = GBVideo(json: videoJSON)
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