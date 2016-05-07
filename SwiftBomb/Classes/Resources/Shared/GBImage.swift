//
//  GBImage.swift
//  GBAPI
//
//  Created by David Fox on 16/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

public struct GBImage {
    
    public let icon: NSURL?
    public let medium: NSURL?
    public let screen: NSURL?
    public let small: NSURL?
    public let superr: NSURL?
    public let thumb: NSURL?
    public let tiny: NSURL?
    public let tags: [String]?
    
    init(json: [String: AnyObject]) {
        
        icon = (json["icon_url"] as? String)?.safeGBImageURL()
        medium = (json["medium_url"] as? String)?.safeGBImageURL()
        screen = (json["screen_url"] as? String)?.safeGBImageURL()
        small = (json["small_url"] as? String)?.safeGBImageURL()
        superr = (json["super_url"] as? String)?.safeGBImageURL()
        thumb = (json["thumb_url"] as? String)?.safeGBImageURL()
        tiny = (json["tiny_url"] as? String)?.safeGBImageURL()
        
        if let tagsString = json["tags"] as? String {
            tags = tagsString.componentsSeparatedByString(", ")
        } else {
            tags = [String]()
        }
    }
}