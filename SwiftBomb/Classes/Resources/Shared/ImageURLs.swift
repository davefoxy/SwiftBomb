//
//  ImageURLs.swift
//  SwiftBomb
//
//  Created by David Fox on 16/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

/**
 A container to hold all the possible URLs for an image hosted on Giant Bomb.
 */
public struct ImageURLs {
    
    /// URL to the icon-sized version of the image.
    public let icon: NSURL?
    
    /// URL to the medium-sized version of the image.
    public let medium: NSURL?
    
    /// URL to the screen-sized version of the image.
    public let screen: NSURL?
    
    /// URL to the small-sized version of the image.
    public let small: NSURL?
    
    /// URL to the supersized version of the image.
    public let supersize: NSURL?
    
    /// URL to the thumbnail version of the image.
    public let thumb: NSURL?
    
    /// URL to the tiny-sized version of the image.
    public let tiny: NSURL?
    
    /// Optional array of tags the image has on the wiki.
    public let tags: [String]?
    
    init(json: [String: AnyObject]) {
        
        icon = (json["icon_url"] as? String)?.safeGBImageURL()
        medium = (json["medium_url"] as? String)?.safeGBImageURL()
        screen = (json["screen_url"] as? String)?.safeGBImageURL()
        small = (json["small_url"] as? String)?.safeGBImageURL()
        supersize = (json["super_url"] as? String)?.safeGBImageURL()
        thumb = (json["thumb_url"] as? String)?.safeGBImageURL()
        tiny = (json["tiny_url"] as? String)?.safeGBImageURL()
        
        if let tagsString = json["tags"] as? String {
            tags = tagsString.componentsSeparatedByString(", ")
        } else {
            tags = [String]()
        }
    }
}