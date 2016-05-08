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
    public let resourceType = ResourceType.Release
    
    /// URL pointing to the release detail resource.
    public private(set) var api_detail_url: NSURL?
    
    /// Date the release was added to Giant Bomb.
    public private(set) var date_added: NSDate?
    
    /// Date the release was last updated on Giant Bomb.
    public private(set) var date_last_updated: NSDate?
    
    /// Brief summary of the release.
    public private(set) var deck: String?
    
    /// Description of the release.
    public private(set) var description: String?
    
    /// Expected date the game will be released.
    public private(set) var expected_release_date: NSDate?
    
    /// Game the release is for.
    public private(set) var game: GameResource?
    
    /// Rating of the release.
    public private(set) var game_rating: (id: Int, name: String)?
    
    /// Unique ID of the release.
    public let id: Int?
    
    /// Main image of the release.
    public private(set) var image: ImageURLs?
    
    /// Maximum players.
    public private(set) var maximum_players: Int?
    
    /// Minimum players.
    public private(set) var minimum_players: Int?
    
    /// Name of the release.
    public private(set) var name: String?
    
    /// The release's platform.
    public private(set) var platform: PlatformResource?
    
    /// The release's product code.
    public private(set) var product_code_value: String?
    
    /// Region the release is responsible for.
    public private(set) var region: (id: Int, name: String)?
    
    /// Date of the release.
    public private(set) var release_date: NSDate?
    
    /// Resolutions available.
    public private(set) var resolutions: [(id: Int, name: String)]?
    
    /// Sound systems.
    public private(set) var sound_systems: [(id: Int, name: String)]?
    
    /// URL pointing to the release on Giant Bomb.
    public private(set) var site_detail_url: NSURL?
    
    /// Widescreen support.
    public private(set) var widescreen_support: Bool?
    
    /// Extended info.
    public var extendedInfo: GameReleaseExtendedInfo?
    
    /// Used to create a `GameReleaseResource` from JSON.
    public init(json: [String : AnyObject]) {
        
        id = json["id"] as? Int
        
        update(json)
    }
    
    func update(json: [String : AnyObject]) {
        
        api_detail_url = (json["api_detail_url"] as? String)?.url()
        date_added = (json["date_added"] as? String)?.dateRepresentation()
        date_last_updated = (json["date_last_updated"] as? String)?.dateRepresentation()
        deck = json["deck"] as? String
        description = json["description"] as? String
        
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
        
        if let gameJSON = json["game"] as? [String: AnyObject] {
            game = GameResource(json: gameJSON)
        } else {
            game = nil
        }
        
        game_rating = (json["game_rating"] as? [String: AnyObject])?.idNameTupleMap()
        
        if let imageJSON = json["image"] as? [String: AnyObject] {
            image = ImageURLs(json: imageJSON)
        } else {
            image = nil
        }
        
        maximum_players = json["maximum_players"] as? Int
        minimum_players = json["minimum_players"] as? Int
        name = json["name"] as? String
        
        if let platformJSON = json["platform"] as? [String: AnyObject] {
            platform = PlatformResource(json: platformJSON)
        }
        
        product_code_value = json["product_code_value"] as? String
        region = (json["region"] as? [String: AnyObject])?.idNameTupleMap()
        release_date = (json["release_date"] as? String)?.dateRepresentation()
        resolutions = (json["resolutions"] as? [[String: AnyObject]])?.idNameTupleMaps()
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
    let developers: [CompanyResource]
    
    /// List of images associated to the release.
    let images: [ImageURLs]
    
    /// Companies who published the release.
    let publishers: [CompanyResource]
    
    /// Used to create a `GameReleaseExtendedInfo` from JSON.
    public init(json: [String : AnyObject]) {
        
        developers = json.jsonMappedResources("developers")
        publishers = json.jsonMappedResources("publishers")
        
        var mutableImages = [ImageURLs]()
        if let imagesJSON = json["images"] as? [[String: AnyObject]] {
            
            for imageJSON in imagesJSON {
                let image = ImageURLs(json: imageJSON)
                mutableImages.append(image)
            }
        }
        images = mutableImages
    }
}