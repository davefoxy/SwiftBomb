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
    public let resourceType = ResourceType.game
    
    /// Array of aliases the game is known by.
    public fileprivate(set) var aliases: [String]?
    
    /// URL pointing to the game detail resource.
    public fileprivate(set) var api_detail_url: URL?
    
    /// Date the game was added to Giant Bomb.
    public fileprivate(set) var date_added: Date?
    
    /// Date the game was last updated on Giant Bomb.
    public fileprivate(set) var date_last_updated: Date?
    
    /// Brief summary of the game.
    public fileprivate(set) var deck: String?
    
    /// Description of the game.
    public fileprivate(set) var description: String?
    
    /// Expected date the game will be released. Only contains the month and year. Fetch extended info for the full date.
    public fileprivate(set) var expected_release_date: Date?
    
    /// Unique ID of the game.
    public let id: Int?
    
    /// Main image of the game.
    public fileprivate(set) var image: ImageURLs?
    
    /// Name of the game.
    public fileprivate(set) var name: String?
    
    /// Number of user reviews of the game on Giant Bomb.
    public fileprivate(set) var number_of_user_reviews: Int?
    
    /// Rating of the first release of the game.
    public fileprivate(set) var original_game_rating: [(id: Int, name: String)]?
    
    /// Date the game was first released.
    public fileprivate(set) var original_release_date: Date?
    
    /// The platforms the game exists on.
    public fileprivate(set) var platforms: [PlatformResource]?
    
    /// URL pointing to the game on Giant Bomb.
    public fileprivate(set) var site_detail_url: URL?
    
    /// A staff review by a member of the Giant Bomb team for the game. Fetch by calling `fetchStaffReview(_:)` upon a game. Note, however, that most games in the database don't have a staff review.
    public internal(set) var staffReview: StaffReviewResource?
    
    /// Extended info.
    public var extendedInfo: GameExtendedInfo?
    
    /// Used to create a `GameResource` from JSON.
    public init(json: [String : AnyObject]) {
        
        id = json["id"] as? Int

        update(json: json)
    }
    
    func update(json: [String : AnyObject]) {
        
        aliases = (json["aliases"] as? String)?.newlineSeparatedStrings() ?? aliases
        api_detail_url = (json["api_detail_url"] as? String)?.url() as URL?? ?? api_detail_url
        date_added = (json["date_added"] as? String)?.dateRepresentation() as Date?? ?? date_added
        date_last_updated = (json["date_last_updated"] as? String)?.dateRepresentation() as Date?? ?? date_last_updated
        deck = json["deck"] as? String ?? deck
        description = json["description"] as? String ?? description
        
        if let expectedReleaseMonth = json["expected_release_month"] as? Int,
            let expectedReleaseYear = json["expected_release_year"] as? Int {
            var dateComponents = DateComponents()
            dateComponents.month = expectedReleaseMonth
            dateComponents.year = expectedReleaseYear
            expected_release_date = Calendar.current.date(from: dateComponents)
        }
        
        if let imageJSON = json["image"] as? [String: AnyObject] {
            image = ImageURLs(json: imageJSON)
        }
        
        name = json["name"] as? String ?? name
        number_of_user_reviews = json["number_of_user_reviews"] as? Int ?? number_of_user_reviews
        original_release_date = (json["original_release_date"] as? String)?.dateRepresentation() as Date?? ?? original_release_date
        site_detail_url = (json["site_detail_url"] as? String)?.url() as URL?? ?? site_detail_url
        
        original_game_rating = (json["original_game_rating"] as? [[String: AnyObject]])?.idNameTupleMaps() ?? original_game_rating
        
        platforms = json.jsonMappedResources("platforms") ?? platforms
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
    public fileprivate(set) var characters: [CharacterResource]?
    
    /// Concepts related to the game.
    public fileprivate(set) var concepts: [ConceptResource]?
    
    /// Companies who developed the game.
    public fileprivate(set) var developers: [CompanyResource]?
    
    /// Expected date the game will be released. The extended info version of this date also includes the day of release.
    public fileprivate(set) var expected_release_date: Date?
    
    /// Characters that first appeared in the game.
    public fileprivate(set) var first_appearance_characters: [CharacterResource]?
    
    /// Concepts that first appeared in the game.
    public fileprivate(set) var first_appearance_concepts: [ConceptResource]?
    
    /// Locations that first appeared in the game.
    public fileprivate(set) var first_appearance_locations: [LocationResource]?
    
    /// Objects that first appeared in the game.
    public fileprivate(set) var first_appearance_objects: [ObjectResource]?
    
    /// People that were first credited in the game.
    public fileprivate(set) var first_appearance_people: [PersonResource]?
    
    /// Franchises related to the game.
    public fileprivate(set) var franchises: [FranchiseResource]?
    
    /// Genres that encompass the game.
    public fileprivate(set) var genres: [GenreResource]?
    
    /// List of images associated to the game.
    public fileprivate(set) var images: [ImageURLs]?
    
    /// Characters killed in the game.
    public fileprivate(set) var killed_characters: [CharacterResource]?
    
    /// Locations related to the game.
    public fileprivate(set) var locations: [LocationResource]?
    
    /// Objects related to the game.
    public fileprivate(set) var objects: [ObjectResource]?
    
    /// Rating of the first release of the game.
    public fileprivate(set) var original_game_rating: [(id: Int, name: String)]?
    
    /// People who have worked with the game.
    public fileprivate(set) var people: [PersonResource]?
    
    /// Companies who published the game.
    public fileprivate(set) var publishers: [CompanyResource]?
    
    /// Releases of the game.
    public fileprivate(set) var releases: [GameReleaseResource]?
    
    /// Staff reviews of the game.
    public fileprivate(set) var reviews: [StaffReviewResource]?
    
    /// Other games similar to the game.
    public fileprivate(set) var similar_games: [GameResource]?
    
    /// Themes that encompass the game.
    public fileprivate(set) var themes: [(id: Int, name: String)]?
    
    /// Videos associated to the game.
    public fileprivate(set) var videos: [VideoURLs]?
    
    /// Used to create a `GameExtendedInfo` from JSON.
    public init(json: [String : AnyObject]) {
        
        update(json)
    }
    
    /// A method used for updating structs. Usually after further requests for more field data.
    public mutating func update(_ json: [String : AnyObject]) {
        
        characters = json.jsonMappedResources("characters") ?? characters
        concepts = json.jsonMappedResources("concepts") ?? concepts
        developers = json.jsonMappedResources("developers") ?? developers
        first_appearance_characters = json.jsonMappedResources("first_appearance_characters") ?? first_appearance_characters
        first_appearance_concepts = json.jsonMappedResources("first_appearance_concepts") ?? first_appearance_concepts
        first_appearance_locations = json.jsonMappedResources("first_appearance_locations") ?? first_appearance_locations
        first_appearance_objects = json.jsonMappedResources("first_appearance_objects") ?? first_appearance_objects
        first_appearance_people = json.jsonMappedResources("first_appearance_people") ?? first_appearance_people
        franchises = json.jsonMappedResources("franchises") ?? franchises
        genres = json.jsonMappedResources("genres") ?? genres
        
        if let imagesJSON = json["images"] as? [[String: AnyObject]] {
            
            images = [ImageURLs]()
            
            for imageJSON in imagesJSON {
                let image = ImageURLs(json: imageJSON)
                images?.append(image)
            }
        }
        
        killed_characters = json.jsonMappedResources("killed_characters") ?? killed_characters
        locations = json.jsonMappedResources("locations") ?? locations
        objects = json.jsonMappedResources("objects") ?? objects
        original_game_rating = (json["original_game_rating"] as? [[String: AnyObject]])?.idNameTupleMaps() ?? original_game_rating
        people = json.jsonMappedResources("people") ?? people
        
        publishers = json.jsonMappedResources("publishers") ?? publishers
        releases = json.jsonMappedResources("releases") ?? releases
        reviews = json.jsonMappedResources("reviews") ?? reviews
        similar_games = json.jsonMappedResources("similar_games") ?? similar_games
        themes = (json["themes"] as? [[String: AnyObject]])?.idNameTupleMaps() ?? themes
        
        if let videosJSON = json["videos"] as? [[String: AnyObject]] {
            
            videos = [VideoURLs]()
            for videoJSON in videosJSON {
                let video = VideoURLs(json: videoJSON)
                videos?.append(video)
            }
        }
        
        if let expectedReleaseDay = json["expected_release_day"] as? Int,
            let expectedReleaseMonth = json["expected_release_month"] as? Int,
            let expectedReleaseYear = json["expected_release_year"] as? Int {
            var dateComponents = DateComponents()
            dateComponents.day = expectedReleaseDay
            dateComponents.month = expectedReleaseMonth
            dateComponents.year = expectedReleaseYear
            expected_release_date = Calendar.current.date(from: dateComponents)
        }
        
    }
}
