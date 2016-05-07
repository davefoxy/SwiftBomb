//
//  GBVideoResource.swift
//  GBAPI
//
//  Created by David Fox on 10/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

final public class GBVideoResource: GBResource {

    /// The resource type
    public let resourceType = ResourceType.Video
    
    /// URL pointing to the video detail resource
    public let api_detail_url: NSURL?
    
    /// Brief summary of the video
    public let deck: String?
    
    /// Unique ID of the video
    public let id: Int?
    
    /// Length (in seconds) of the video
    public let length_seconds: Int?
    
    /// Name of the video
    public let name: String?
    
    /// Date the video was published on Giant Bomb
    public let publish_date: NSDate?
    
    /// URL pointing to the video on Giant Bomb
    public let site_detail_url: NSURL?
    
    /// Author of the video
    public let user: String?
    
    /// Video category
    public let video_type: String?
    
    /// Youtube ID for the video
    public let youtube_id: String?
    
    /// The video's filename
    public let url: String?
    
    // Container for the video's image
    public let image: GBImage?
    
    // Container for the video's URLs
    public let video: GBVideo?
    
    /// Extended info
    public var extendedInfo: GBUnusedExtendedInfo?
    
    public init(json: [String: AnyObject]) {
        
        api_detail_url = (json["api_detail_url"] as? String)?.url()
        deck = json["deck"] as? String
        id = json["id"] as? Int
        length_seconds = json["length_seconds"] as? Int
        name = json["name"] as? String
        publish_date = (json["publish_date"] as? String)?.dateRepresentation()
        site_detail_url = (json["site_detail_url"] as? String)?.url()
        user = json["user"] as? String
        video_type = json["video_type"] as? String
        youtube_id = json["youtube_id"] as? String
        url = json["url"] as? String
        
        if let imageJSON = json["image"] as? JSONDict {
            image = GBImage(json: imageJSON)
        } else {
            image = nil
        }
        
        video = GBVideo(json: json)
    }
    
    public var prettyDescription: String {
        return name ?? "Video \(id)"
    }
}
