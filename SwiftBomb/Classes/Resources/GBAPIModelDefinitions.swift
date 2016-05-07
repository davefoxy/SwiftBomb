//
//  ModelDefinitions.swift
//  GBAPI
//
//  Created by David Fox on 23/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

/**
 A tuple containing useful, basic information about a `GBResource`
 */
public typealias GBResourceSummary = (id: Int, prettyDescription: String, image: GBImageURLs?, resourceType: ResourceType)

/**
 A simple tuple which contains information regarding a "Platform" on the Giant Bomb wiki. Examples are "Playstation 4" and "Xbox One". Resources such as `GBGameResource` often contain an array of these to signify which platforms the game is available on.
 */
public typealias GBPlatformResource = (id: Int, name: String, abbreviation: String)

/**
 An empty struct type for resources which don't contain extended info. Included primarily to satisfy the requirements of the `GBResource` protocol.
 */
public struct GBUnusedExtendedInfo: GBResourceExtendedInfo { public init(json: [String : AnyObject]) {} }

/**
 A protocol describing any of the main resources available on the Giant Bomb wiki. Includes base information required by the framework in creating and parsing resource objects.
 */
public protocol GBResource: class {
    
    /// An associated type to describe the class type of the resource's `extendedInfo` property.
    associatedtype ExtendedInfoAlias: GBResourceExtendedInfo
    
    /// The base init method for parsing the API's response JSON to a native resource object.
    init(json: [String: AnyObject])
    
    /// Fetches extended info for an already partially-parsed resource.
    func fetchExtendedInfo(completion: (error: GBAPIError?) -> Void)
    
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
internal protocol GBResourceUpdating: GBResource {
    
    /// Used to parse incoming json to the resource's properties
    func update(json: [String: AnyObject])
}

/**
 A protocol which all resource's `extendedInfo` struct types must adhere to.
 */
public protocol GBResourceExtendedInfo {
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

extension GBResource {
    
    /**
     Convenience method to fetch a `GBResourceSummary` instance which describes top-level information about any resource.
     */
    func resourceSummary() -> GBResourceSummary? {
        
        guard let id = id else {
            return nil
        }
        
        return GBResourceSummary(id, prettyDescription: self.prettyDescription, image: GBImageURLs(json: [:]), self.resourceType) // TODO: bring the image back in
    }
}
