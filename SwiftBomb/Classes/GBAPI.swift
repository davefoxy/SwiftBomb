//
//  GBAPI.swift
//  GBAPI
//
//  Created by David Fox on 10/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

/**
 A struct which the client app is required to instantiate and pass into the API instance containing the user's API key, optional level of logging and user agent.
 */
public struct GBAPIConfiguration {
    
    /// An enum specifying the various levels of logging the framework should make. `None` should be used in production.
    public enum GBAPILoggingLevel {
        
        /// No logs will be made by the framework.
        case None
        
        /// Requests will be logged when being sent to the Giant Bomb API.
        case Requests
        
        /// Requests and the resulting response headers will be logged.
        case RequestsAndResponses
    }
    
    let apiKey: String
    let userAgentIdentifier: String?
    let baseURL = NSURL(string: "http://www.giantbomb.com")!
    let baseAPIURL = NSURL(string: "http://www.giantbomb.com/api")!
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
    
    /// Client apps **must** call this method and pass in an instance of `GBAPIConfiguration`. Typically happens in the application delegate.
    public static func configure(configuration: GBAPIConfiguration) {
        
        let api = GBAPI.framework
        
        let authenticationStore = GBAPIKeychainStore()
        api.requestFactory = GBAPIRequestFactory(configuration: configuration, authenticationStore: authenticationStore)
        api.networkingManager = GBAPIURLSessionManager(configuration: configuration)
    }
}
