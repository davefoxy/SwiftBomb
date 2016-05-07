//
//  GBAPI.swift
//  GBAPI
//
//  Created by David Fox on 10/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

public struct GBAPIConfiguration {
    
    var apiKey: String
    var userAgentIdentifier: String
    let baseURL = NSURL(string: "http://www.giantbomb.com/api/")!
    
    public init(apiKey: String, userAgentIdentifier: String) {
        
        self.apiKey = apiKey
        self.userAgentIdentifier = userAgentIdentifier
    }
}

public class GBAPI {
    
    static let framework: GBAPI = GBAPI()
    var requestFactory: GBAPIRequestFactory?
    var networkingManager: GBAPINetworkingManager?
    
    public static func configure(configuration: GBAPIConfiguration) {
        
        let api = GBAPI.framework
        
        let authenticationStore = GBAPIKeychainStore()
        api.requestFactory = GBAPIRequestFactory(configuration: configuration, authenticationStore: authenticationStore)
        api.networkingManager = GBAPIURLSessionManager(configuration: configuration)
    }
}
