//
//  StaffReviewResource.swift
//  SwiftBomb
//
//  Created by David Fox on 01/05/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

/**
 A class representing a *Staff Review* on the Giant Bomb wiki. These are reviews specifically written by the editorial team at Giant Bomb.
 
 To retrieve extended info for a staff review, call `fetchExtendedInfo(_:)` upon it.
 */
final public class StaffReviewResource: ResourceUpdating {
    
    /// The resource type.
    public fileprivate(set) var resourceType = ResourceType.review
    
    /// URL pointing to the review detail resource.
    public fileprivate(set) var api_detail_url: URL?
    
    /// Brief summary of the review.
    public fileprivate(set) var deck: String?
    
    /// Description of the review.
    public fileprivate(set) var description: String?
    
    /// Name of the Downloadable Content package.
    public fileprivate(set) var dlc_name: String?
    
    /// Game the review is for.
    public fileprivate(set) var game: GameResource?
    
    /// Date the review was published on Giant Bomb.
    public fileprivate(set) var publish_date: Date?
    
    /// Release of game for review.
    public fileprivate(set) var release: GameResource?
    
    /// Name of the review's author.
    public fileprivate(set) var reviewer: String?
    
    /// The score given to the game on a scale of 1 to 5.
    public fileprivate(set) var score: Int?
    
    /// URL pointing to the review on Giant Bomb.
    public fileprivate(set) var site_detail_url: URL?
    
    /// IDs don't exist for staff reviews in the Giant Bomb database! But to satisfy the `Resource` protocol...
    public fileprivate(set) var id: Int? = 0
    
    /// Take the image from the game
    public var image: ImageURLs? {
        get {
            return game?.image
        }
    }
    
    /// Extended info. Unused for this resource type.
    public var extendedInfo: UnusedExtendedInfo?
    
    /// Used to create a `StaffReviewResource` from JSON.
    public init(json: [String: AnyObject]) {
        
        update(json: json)
    }
    
    func update(json: [String : AnyObject]) {
        
        api_detail_url = (json["api_detail_url"] as? String)?.url() as URL?? ?? api_detail_url
        deck = json["deck"] as? String ?? deck
        description = json["description"] as? String ?? description
        dlc_name = json["dlc_name"] as? String ?? dlc_name
        
        if let gameJSON = json["game"] as? [String: AnyObject] {
            game = GameResource(json: gameJSON)
        }
        
        publish_date = (json["publish_date"] as? String)?.dateRepresentation() as Date?? ?? publish_date
        
        if let releaseJSON = json["release"] as? [String: AnyObject] {
            release = GameResource(json: releaseJSON)
        }
        
        reviewer = json["reviewer"] as? String ?? reviewer
        score = json["score"] as? Int ?? score
        site_detail_url = (json["site_detail_url"] as? String)?.url() as URL?? ?? site_detail_url
    }
    
    /// Pretty description of the staff review.
    public var prettyDescription: String {
        if let game = game, let gameName = game.name {
            return "\(gameName) Staff Review"
        }
        
        return "Review"
    }
}
