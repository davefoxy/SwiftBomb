//
//  ComingUpItemResource.swift
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
        self = ComingUpItemType(rawValue: safeRawValueOrUnknown.lowercaseString) ?? .Unknown
    }
}

/**
 A class representing an upcoming post on Giant Bomb. These are basically the contents of the "Coming up on Giant Bomb" panel on the Giant Bomb homepage.
 */
final public class ComingUpItemResource {
    
    /// The resource type.
    public let resourceType = ResourceType.ComingUpItem
    
    /// An `ComingUpItemType` describing this item.
    public let type: ComingUpItemType
    
    /// The title of the item.
    public let title: String?
    
    /// URL pointing to the image of the item.
    public let imageURL: NSURL?
    
    /// The date this item will go live on Giant Bomb. This is converted (by Giant Bomb) to the timezone the device is calling from.
    public let date: NSDate?
    
    /// Boolean indicating whether or not this a premium item or not.
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
        self.imageURL = (json["image"] as? String)?.url()
        self.date = (json["date"] as? String)?.comingUpItemDateRepresentation()
        self.premium = json["premium"] as? Bool ?? false
    }
}