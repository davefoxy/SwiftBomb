//
//  VideoURLs.swift
//  SwiftBomb
//
//  Created by David Fox on 17/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

/**
 A container to hold all the possible URLs for a video hosted on Giant Bomb.
 */
public struct VideoURLs {
    
    /// URL to the HD version of the video
    public let hd: URL?
    
    /// URL to the High Res version of the video
    public let high: URL?
    
    /// URL to the Low Res version of the video
    public let low: URL?
    
    init(json: [String: AnyObject]) {
        
        hd = (json["hd_url"] as? String)?.url() as URL?
        high = (json["high_url"] as? String)?.url() as URL?
        low = (json["low_url"] as? String)?.url() as URL?
    }
}
