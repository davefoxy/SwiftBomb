//
//  VideoResource.swift
//  SwiftBomb
//
//  Created by David Fox on 10/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

/**
 A class representing a *Video* on the Giant Bomb database. This includes quick looks and other Giant Bomb-created content as well as trailers for games amongst others.
 
 To retrieve extended info for a video, call `fetchExtendedInfo(_:)` upon it.
 */
final public class VideoResource: ResourceUpdating {

    /// The resource type.
    public let resourceType = ResourceType.Video
    
    /// URL pointing to the video detail resource.
    public fileprivate(set) var api_detail_url: URL?
    
    /// Brief summary of the video.
    public fileprivate(set) var deck: String?
    
    /// Unique ID of the video.
    public let id: Int?
    
    /// Length (in seconds) of the video.
    public fileprivate(set) var length_seconds: Int?
    
    /// Name of the video.
    public fileprivate(set) var name: String?
    
    /// Date the video was published on Giant Bomb.
    public fileprivate(set) var publish_date: Date?
    
    /// URL pointing to the video on Giant Bomb.
    public fileprivate(set) var site_detail_url: URL?
    
    /// Author of the video.
    public fileprivate(set) var user: String?
    
    /// Video category.
    public fileprivate(set) var video_type: String?
    
    /// Youtube ID for the video.
    public fileprivate(set) var youtube_id: String?
    
    /// The video's filename.
    public fileprivate(set) var url: String?
    
    /// Container for the video's image.
    public fileprivate(set) var image: ImageURLs?
    
    /// Container for the video's URLs.
    public fileprivate(set) var urls: VideoURLs?
    
    /// Extended info. Unused for this resource type.
    public var extendedInfo: UnusedExtendedInfo?
    
    /// Used to create a `VideoResource` from JSON.
    public init(json: [String : AnyObject]) {
        
        id = json["id"] as? Int
        
        update(json: json)
    }
    
    func update(json: [String : AnyObject]) {
        
        api_detail_url = (json["api_detail_url"] as? String)?.url() as URL? ?? api_detail_url
        
        
        
        
        
        
        
        deck = json["deck"] as? String ?? deck
        length_seconds = json["length_seconds"] as? Int ?? length_seconds
        name = json["name"] as? String ?? name
        publish_date = (json["publish_date"] as? String)?.dateRepresentation() as Date?? ?? publish_date
        site_detail_url = (json["site_detail_url"] as? String)?.url() as URL?? ?? site_detail_url
        user = json["user"] as? String ?? user
        video_type = json["video_type"] as? String ?? video_type
        youtube_id = json["youtube_id"] as? String ?? youtube_id
        url = json["url"] as? String ?? url
        
        if let imageJSON = json["image"] as? [String: AnyObject] {
            image = ImageURLs(json: imageJSON)
        }
        
        urls = VideoURLs(json: json)
    }
    
    /// Pretty description of the video.
    public var prettyDescription: String {
        return name ?? "Video \(id)"
    }
}
