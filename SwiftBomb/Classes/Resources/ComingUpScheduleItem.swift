//
//  ComingUpScheduleItem.swift
//  Pods
//
//  Created by David Fox on 23/07/2016.
//
//

import Foundation

/**
 An enum describing the type of an upcoming item on Giant Bomb
 */
public enum ComingUpItemType: String {
    
    /// An unknown type of upcoming item.
    case Unknown = "unknown"
    
    /// Live show.
    case LiveShow = "live show"
    
    /// Video.
    case Video = "video"
    
    /// Article.
    case Article = "article"
    
    init(safeRawValueOrUnknown: String) {
        self = ComingUpItemType(rawValue: safeRawValueOrUnknown.lowercased()) ?? .Unknown
    }
}

/**
 A struct representing an upcoming post on Giant Bomb. These are basically the individual items on the "Coming up on Giant Bomb" panel on the Giant Bomb homepage.
 */
public struct ComingUpScheduleItem {
    
    /// The resource type.
    public let resourceType = ResourceType.ComingUpItem
    
    /// An `ComingUpItemType` describing this item. Note, this will be `ComingUpItemType.Unknown` for currently live streams found in `ComingUpSchedule`'s `liveNow` property.
    public let type: ComingUpItemType
    
    /// The title of the item.
    public let title: String?
    
    /// URL pointing to the image of the item.
    public let imageURL: URL?
    
    /// The date this item will go live on Giant Bomb. SwiftBomb will convert the PDT time Giant Bomb returns to an NSDate in the UTC timezone. Set your NSDateFormatter's `timeZone` property to `NSTimeZone.localTimeZone()` to adjust it correctly to your user's device. This will not be available for currently live streams found in `ComingUpSchedule`'s `liveNow` property.
    public let date: Date?
    
    /// Boolean indicating whether or not this a premium item or not. This will not be available for currently live streams found in `ComingUpSchedule`'s `liveNow` property.
    public let premium: Bool
    
    /// Used to create an `UpcomingItemResource` from JSON.
    public init(json: [String: AnyObject]) {
        
        if let type = json["type"] as? String {
            self.type = ComingUpItemType(safeRawValueOrUnknown: type)
        }
        else {
            self.type = .Unknown
        }
        
        self.title = json["title"] as? String
        self.imageURL = (json["image"] as? String)?.url() as URL?
        self.date = (json["date"] as? String)?.comingUpItemDateRepresentation() as Date?
        self.premium = json["premium"] as? Bool ?? false
    }
}
