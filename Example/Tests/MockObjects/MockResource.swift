//
//  MockResource.swift
//  SwiftBomb
//
//  Created by David Fox on 08/05/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation
@testable import SwiftBomb

final public class MockResource: ResourceUpdating {
    
    public let resourceType = ResourceType.Unknown
    public let id: Int?
    public var extendedInfo: MockResourceExtendedInfo?
    public var image: ImageURLs?
    public var deck: String?
    
    public init(json: [String : AnyObject]) {
        
        id = json["id"] as? Int
    }
    
    func update(json: [String : AnyObject]) {
        
    }
    
    public func fetchExtendedInfo(fields: [String]? = nil, completion: (error: RequestError?) -> Void) {
        
    }
    
    public var prettyDescription: String {
        return "[Mock Resource]"
    }
}

public struct MockResourceExtendedInfo: ResourceExtendedInfo {
    
    var json: [String: AnyObject]
    
    public init(json: [String : AnyObject]) {
        
        self.json = json
    }
}