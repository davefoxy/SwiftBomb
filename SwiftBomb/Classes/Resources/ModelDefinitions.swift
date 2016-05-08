//
//  ModelDefinitions.swift
//  SwiftBomb
//
//  Created by David Fox on 23/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

/**
 A tuple containing useful, basic information about a `Resource`
 */
public typealias ResourceSummary = (id: Int, prettyDescription: String, resourceType: ResourceType)

/**
 A simple tuple which contains information regarding a *Platform* on the Giant Bomb wiki. Examples are *Playstation 4* and *Xbox One*. Resources such as `GameResource` often contain an array of these to signify which platforms the game is available on.
 */
public typealias PlatformResource = (id: Int, name: String, abbreviation: String)

/**
 An empty struct type for resources which don't contain extended info. Included primarily to satisfy the requirements of the `Resource` protocol.
 */
public struct UnusedExtendedInfo: ResourceExtendedInfo { public init(json: [String : AnyObject]) {} }

/**
 A protocol describing any of the main resources available on the Giant Bomb wiki. Includes base information required by the framework in creating and parsing resource objects.
 */
public protocol Resource: class {
    
    /// An associated type to describe the class type of the resource's `extendedInfo` property.
    associatedtype ExtendedInfoAlias: ResourceExtendedInfo
    
    /// The base init method for parsing the API's response JSON to a native resource object.
    init(json: [String: AnyObject])
    
    /// Fetches extended info for an already partially-parsed resource.
    func fetchExtendedInfo(completion: (error: RequestError?) -> Void)
    
    /// The unique ID for a resource.
    var id: Int? { get }
    
    /// A, potentially user-facing description of the resource. Not localized.
    var prettyDescription: String { get }
    
    /// The type of this resource.
    var resourceType: ResourceType { get }
    
    /// Extended info about the resource. Fetch this object by calling `fetchExtendedInfo` upon an instance of it.
    var extendedInfo: ExtendedInfoAlias? { get set }
}

/**
 An internal-only protocol which allows updating of resources.
 */
internal protocol ResourceUpdating: Resource {
    
    /// Used to parse incoming json to the resource's properties
    func update(json: [String: AnyObject])
}

/**
 A protocol which all resource's `extendedInfo` struct types must adhere to.
 */
public protocol ResourceExtendedInfo {
    init(json: [String: AnyObject])
}

/**
 An enum providing the type of any resource returned by the Giant Bomb API.
 */
public enum ResourceType: String {
    
    case Accessory = "accessory"
    case Character = "character"
    case Company = "company"
    case Concept = "concept"
    case Franchise = "franchise"
    case Game = "game"
    case Genre = "genre"
    case Location = "location"
    case Object = "object"
    case Person = "person"
    case Release = "release"
    case Video = "video"
    case Review = "review"
    case Unknown = "unknown"
    
    init(safeRawValueOrUnknown: String) {
        self = ResourceType(rawValue: safeRawValueOrUnknown) ?? .Unknown
    }
}

extension Resource {
    
    /**
     Convenience method to fetch a `ResourceSummary` instance which describes top-level information about any resource.
     */
    func resourceSummary() -> ResourceSummary? {
        
        guard let id = id else {
            return nil
        }
        
        return ResourceSummary(id, prettyDescription: self.prettyDescription, self.resourceType)
    }
}
