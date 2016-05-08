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
    public private(set) var api_detail_url: NSURL?
    
    /// Brief summary of the video.
    public private(set) var deck: String?
    
    /// Unique ID of the video.
    public let id: Int?
    
    /// Length (in seconds) of the video.
    public private(set) var length_seconds: Int?
    
    /// Name of the video.
    public private(set) var name: String?
    
    /// Date the video was published on Giant Bomb.
    public private(set) var publish_date: NSDate?
    
    /// URL pointing to the video on Giant Bomb.
    public private(set) var site_detail_url: NSURL?
    
    /// Author of the video.
    public private(set) var user: String?
    
    /// Video category.
    public private(set) var video_type: String?
    
    /// Youtube ID for the video.
    public private(set) var youtube_id: String?
    
    /// The video's filename.
    public private(set) var url: String?
    
    /// Container for the video's image.
    public private(set) var image: ImageURLs?
    
    /// Container for the video's URLs.
    public private(set) var urls: VideoURLs?
    
    /// Extended info. Unused for this resource type.
    public var extendedInfo: UnusedExtendedInfo?
    
    /// Used to create a `VideoResource` from JSON.
    public init(json: [String : AnyObject]) {
        
        id = json["id"] as? Int
        
        update(json)
    }
    
    func update(json: [String : AnyObject]) {
        
        api_detail_url = (json["api_detail_url"] as? String)?.url()
        deck = json["deck"] as? String
        length_seconds = json["length_seconds"] as? Int
        name = json["name"] as? String
        publish_date = (json["publish_date"] as? String)?.dateRepresentation()
        site_detail_url = (json["site_detail_url"] as? String)?.url()
        user = json["user"] as? String
        video_type = json["video_type"] as? String
        youtube_id = json["youtube_id"] as? String
        url = json["url"] as? String
        
        if let imageJSON = json["image"] as? [String: AnyObject] {
            image = ImageURLs(json: imageJSON)
        } else {
            image = nil
        }
        
        urls = VideoURLs(json: json)
    }
    
    /// Pretty description of the video.
    public var prettyDescription: String {
        return name ?? "Video \(id)"
    }
}
