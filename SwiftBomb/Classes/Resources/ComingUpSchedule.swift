//
//  ComingUpSchedule.swift
//  Pods
//
//  Created by David Fox on 23/07/2016.
//
//

import Foundation

/**
 A struct representing the current schedule for upcoming streams on Giant Bomb. It essentially wraps up currently live and upcoming posts as detailed at the top of GiantBomb.com and the homepage's "Coming up on Giant Bomb" panel. 
 */
public struct ComingUpSchedule {
    
    /// An optional instance of `ComingUpScheduleItem` describing any currently-live stream or event taking place when the request is made.
    public let liveNow: ComingUpScheduleItem?
    
    /// An array of `ComingUpScheduleItem` instances describing upcoming posts on Giant Bomb. This mirrors the contents of the "Coming up on Giant Bomb" panel on the site's homepage.
    public let upcoming: [ComingUpScheduleItem]
    
    init(json: [String: AnyObject]) {
        
        if let liveNowJSON = json["liveNow"] as? [String: AnyObject] {
            liveNow = ComingUpScheduleItem(json: liveNowJSON)
        }
        else {
            liveNow = nil
        }
        
        if let comingUpItemDicts = json["upcoming"] as? [[String: AnyObject]] {
            
            var upcoming = [ComingUpScheduleItem]()
            for comingUpItemDict in comingUpItemDicts {
                
                let comingUpItem = ComingUpScheduleItem(json: comingUpItemDict)
                upcoming.append(comingUpItem)
            }
            self.upcoming = upcoming
        }
        else {
            upcoming = [ComingUpScheduleItem]()
        }
    }
}