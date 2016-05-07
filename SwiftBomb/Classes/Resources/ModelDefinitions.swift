//
//  ModelDefinitions.swift
//  GBAPI
//
//  Created by David Fox on 23/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

public typealias GBResourceSummary = (id: Int, prettyDescription: String, image: GBImage?, resourceType: ResourceType)

public protocol GBResource: class {
    
    associatedtype ExtendedInfoAlias: GBResourceExtendedInfo
    
    init(json: [String: AnyObject])
    
    var id: Int? { get }
    var prettyDescription: String { get }
    var resourceType: ResourceType { get }
    var extendedInfo: ExtendedInfoAlias? { get set }
}

internal protocol GBResourceUpdating: GBResource {
    
    func update(json: [String: AnyObject])
}

public protocol GBResourceExtendedInfo {
    init(json: [String: AnyObject])
}

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
    
    func resourceSummary() -> GBResourceSummary? {
        
        guard let id = id else {
            return nil
        }
        
        return GBResourceSummary(id, prettyDescription: self.prettyDescription, image: GBImage(json: [:]), self.resourceType)
    }
}

public typealias GBPlatformResource = (id: Int, name: String, abbreviation: String)

public struct GBUnusedExtendedInfo: GBResourceExtendedInfo { public init(json: [String : AnyObject]) {} }