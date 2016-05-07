//
//  GBVideoResource.swift
//  GBAPI
//
//  Created by David Fox on 10/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

final public class GBVideoResource: GBResourceUpdating {

    /// The resource type
    public let resourceType = ResourceType.Video
    
    /// URL pointing to the video detail resource
    public private(set) var api_detail_url: NSURL?
    
    /// Brief summary of the video
    public private(set) var deck: String?
    
    /// Unique ID of the video
    public let id: Int?
    
    /// Length (in seconds) of the video
    public private(set) var length_seconds: Int?
    
    /// Name of the video
    public private(set) var name: String?
    
    /// Date the video was published on Giant Bomb
    public private(set) var publish_date: NSDate?
    
    /// URL pointing to the video on Giant Bomb
    public private(set) var site_detail_url: NSURL?
    
    /// Author of the video
    public private(set) var user: String?
    
    /// Video category
    public private(set) var video_type: String?
    
    /// Youtube ID for the video
    public private(set) var youtube_id: String?
    
    /// The video's filename
    public private(set) var url: String?
    
    // Container for the video's image
    public private(set) var image: GBImageURLs?
    
    // Container for the video's URLs
    public private(set) var video: GBVideoURLs?
    
    /// Extended info
    public var extendedInfo: GBUnusedExtendedInfo?
    
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
        
        if let imageJSON = json["image"] as? JSONDict {
            image = GBImageURLs(json: imageJSON)
        } else {
            image = nil
        }
        
        video = GBVideoURLs(json: json)
    }
    
    public var prettyDescription: String {
        return name ?? "Video \(id)"
    }
}
