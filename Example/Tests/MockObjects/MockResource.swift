//
//  MockResource.swift
//  SwiftBomb
//
//  Created by David Fox on 08/05/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
@testable import SwiftBomb

final public class MockResource: ResourceUpdating {
    
    public let resourceType = ResourceType.Unknown
    public let id: Int?
    public var extendedInfo: MockResourceExtendedInfo?
    
    public init(json: [String : AnyObject]) {
        
        id = json["id"] as? Int
    }
    
    func update(json: [String : AnyObject]) {
        
    }
    
    public func fetchExtendedInfo(completion: (error: RequestError?) -> Void) {
        
//        let test = MockNetworkingManager(configuration: nil)
//        test.performDetailRequest(request, resource: self, completion: completion)
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