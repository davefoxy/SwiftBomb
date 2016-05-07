//
//  GBAPI.swift
//  GBAPI
//
//  Created by David Fox on 10/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

public struct GBAPIConfiguration {
    
    public enum GBAPILoggingLevel {
        case None
        case Requests
        case RequestsAndResponses
    }
    
    let apiKey: String
    let userAgentIdentifier: String?
    let baseURL = NSURL(string: "http://www.giantbomb.com")!
    let baseAPIURL = NSURL(string: "http://www.giantbomb.com/api/")!
    let loggingLevel: GBAPILoggingLevel
    
    public init(apiKey: String, loggingLevel: GBAPILoggingLevel = .RequestsAndResponses, userAgentIdentifier: String? = nil) {
        
        self.apiKey = apiKey
        self.loggingLevel = loggingLevel
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
