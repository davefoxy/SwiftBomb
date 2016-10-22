//
//  GameReleaseResource.swift
//  SwiftBomb
//
//  Created by David Fox on 07/05/2016.
//
//

import Foundation

/**
 A class representing a *Game Release* on the Giant Bomb wiki. Examples include *Grand Theft Auto: UK Release* and *Spelunky: Vita Edition*. The distinction between a `GameResource` and `GameReleaseResource` can be summarised that *a game consists of releases* and they typically refer to releases in different countries, collector's editions etc.
 
 To retrieve extended info for a game release, call `fetchExtendedInfo(_:)` upon it.
 */
final public class GameReleaseResource: ResourceUpdating {
    
    /// The resource type.
    public let resourceType = ResourceType.release
    
    /// URL pointing to the release detail resource.
    public fileprivate(set) var api_detail_url: URL?
    
    /// Date the release was added to Giant Bomb.
    public fileprivate(set) var date_added: Date?
    
    /// Date the release was last updated on Giant Bomb.
    public fileprivate(set) var date_last_updated: Date?
    
    /// Brief summary of the release.
    public fileprivate(set) var deck: String?
    
    /// Description of the release.
    public fileprivate(set) var description: String?
    
    /// Expected date the game will be released.
    public fileprivate(set) var expected_release_date: Date?
    
    /// Game the release is for.
    public fileprivate(set) var game: GameResource?
    
    /// Rating of the release.
    public fileprivate(set) var game_rating: (id: Int, name: String)?
    
    /// Unique ID of the release.
    public let id: Int?
    
    /// Main image of the release.
    public fileprivate(set) var image: ImageURLs?
    
    /// Maximum players.
    public fileprivate(set) var maximum_players: Int?
    
    /// Minimum players.
    public fileprivate(set) var minimum_players: Int?
    
    /// Name of the release.
    public fileprivate(set) var name: String?
    
    /// The release's platform.
    public fileprivate(set) var platform: PlatformResource?
    
    /// The release's product code.
    public fileprivate(set) var product_code_value: String?
    
    /// Region the release is responsible for.
    public fileprivate(set) var region: (id: Int, name: String)?
    
    /// Date of the release.
    public fileprivate(set) var release_date: Date?
    
    /// Resolutions available.
    public fileprivate(set) var resolutions: [(id: Int, name: String)]?
    
    /// Sound systems.
    public fileprivate(set) var sound_systems: [(id: Int, name: String)]?
    
    /// URL pointing to the release on Giant Bomb.
    public fileprivate(set) var site_detail_url: URL?
    
    /// Widescreen support.
    public fileprivate(set) var widescreen_support: Bool?
    
    /// Extended info.
    public var extendedInfo: GameReleaseExtendedInfo?
    
    /// Used to create a `GameReleaseResource` from JSON.
    public init(json: [String : AnyObject]) {
        
        id = json["id"] as? Int
        
        update(json: json)
    }
    
    func update(json: [String : AnyObject]) {
        
        api_detail_url = (json["api_detail_url"] as? String)?.url() as URL?? ?? api_detail_url
        date_added = (json["date_added"] as? String)?.dateRepresentation() as Date?? ?? date_added
        date_last_updated = (json["date_last_updated"] as? String)?.dateRepresentation() as Date?? ?? date_last_updated
        deck = json["deck"] as? String ?? deck
        description = json["description"] as? String ?? description
        
        if let expectedReleaseDay = json["expected_release_day"] as? Int,
            let expectedReleaseMonth = json["expected_release_month"] as? Int,
            let expectedReleaseYear = json["expected_release_year"] as? Int {
            var dateComponents = DateComponents()
            dateComponents.day = expectedReleaseDay
            dateComponents.month = expectedReleaseMonth
            dateComponents.year = expectedReleaseYear
            expected_release_date = Calendar.current.date(from: dateComponents)
        }
        
        if let gameJSON = json["game"] as? [String: AnyObject] {
            game = GameResource(json: gameJSON)
        }
        
        game_rating = (json["game_rating"] as? [String: AnyObject])?.idNameTupleMap() ?? game_rating
        
        if let imageJSON = json["image"] as? [String: AnyObject] {
            image = ImageURLs(json: imageJSON)
        }
        
        maximum_players = json["maximum_players"] as? Int ?? maximum_players
        minimum_players = json["minimum_players"] as? Int ?? minimum_players
        name = json["name"] as? String ?? name
        
        if let platformJSON = json["platform"] as? [String: AnyObject] {
            platform = PlatformResource(json: platformJSON)
        }
        
        product_code_value = json["product_code_value"] as? String ?? product_code_value
        region = (json["region"] as? [String: AnyObject])?.idNameTupleMap() ?? region
        release_date = (json["release_date"] as? String)?.dateRepresentation() as Date?? ?? release_date
        resolutions = (json["resolutions"] as? [[String: AnyObject]])?.idNameTupleMaps() ?? resolutions
    }
    
    /// Pretty description of the release.
    public var prettyDescription: String {
        return name ?? "Release \(id)"
    }
}

/**
 Struct containing extended information for `GameReleaseResource`s. To retrieve, call `fetchExtendedInfo(_:)` upon the original resource then access the data on the resource's `extendedInfo` property.
 */
public struct GameReleaseExtendedInfo: ResourceExtendedInfo {
    
    /// Companies who developed the release.
    public fileprivate(set) var developers: [CompanyResource]?
    
    /// List of images associated to the release.
    public fileprivate(set) var images: [ImageURLs]?
    
    /// Companies who published the release.
    public fileprivate(set) var publishers: [CompanyResource]?
    
    /// Used to create a `GameReleaseExtendedInfo` from JSON.
    public init(json: [String : AnyObject]) {
        
        update(json)
    }
    
    /// A method used for updating structs. Usually after further requests for more field data.
    public mutating func update(_ json: [String : AnyObject]) {
        
        developers = json.jsonMappedResources("developers") ?? developers
        publishers = json.jsonMappedResources("publishers") ?? publishers
        
        if let imagesJSON = json["images"] as? [[String: AnyObject]] {
            
            images = [ImageURLs]()
            for imageJSON in imagesJSON {
                let image = ImageURLs(json: imageJSON)
                images?.append(image)
            }
        }
    }
}
