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
    public let icon: URL?
    
    /// URL to the medium-sized version of the image.
    public let medium: URL?
    
    /// URL to the screen-sized version of the image.
    public let screen: URL?
    
    /// URL to the small-sized version of the image.
    public let small: URL?
    
    /// URL to the supersized version of the image.
    public let supersize: URL?
    
    /// URL to the thumbnail version of the image.
    public let thumb: URL?
    
    /// URL to the tiny-sized version of the image.
    public let tiny: URL?
    
    /// Optional array of tags the image has on the wiki.
    public let tags: [String]?
    
    init(json: [String: AnyObject]) {
        
        icon = (json["icon_url"] as? String)?.safeGBImageURL() as URL?
        medium = (json["medium_url"] as? String)?.safeGBImageURL() as URL?
        screen = (json["screen_url"] as? String)?.safeGBImageURL() as URL?
        small = (json["small_url"] as? String)?.safeGBImageURL() as URL?
        supersize = (json["super_url"] as? String)?.safeGBImageURL() as URL?
        thumb = (json["thumb_url"] as? String)?.safeGBImageURL() as URL?
        tiny = (json["tiny_url"] as? String)?.safeGBImageURL() as URL?
        
        if let tagsString = json["tags"] as? String {
            tags = tagsString.components(separatedBy: ", ")
        } else {
            tags = [String]()
        }
    }
}
