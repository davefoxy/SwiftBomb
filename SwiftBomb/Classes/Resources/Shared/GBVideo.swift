//
//  GBVideo.swift
//  GBAPI
//
//  Created by David Fox on 17/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

public struct GBVideo {
    
    /// URL to the HD version of the video
    let hd: NSURL?
    
    /// URL to the High Res version of the video
    let high: NSURL?
    
    /// URL to the Low Res version of the video
    let low: NSURL?
    
    init(json: [String: AnyObject]) {
        
        hd = (json["hd_url"] as? String)?.url()
        high = (json["high_url"] as? String)?.url()
        low = (json["low_url"] as? String)?.url()
    }
}