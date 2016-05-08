//
//  SwiftBomb.swift
//  SwiftBomb
//
//  Created by David Fox on 10/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

/**
 A struct which the client app is required to instantiate and pass into the API instance containing the user's API key, optional level of logging and user agent.
 */
public struct Configuration {
    
    /// An enum specifying the various levels of logging the framework should make. `None` should be used in production.
    public enum LoggingLevel {
        
        /// No logs will be made by the framework.
        case None
        
        /// Requests will be logged when being sent to the Giant Bomb API.
        case Requests
        
        /// Requests and the resulting response headers will be logged.
        case RequestsAndResponses
    }
    
    let apiKey: String
    let userAgentIdentifier: String?
    let baseAPIURL = NSURL(string: "http://www.giantbomb.com/api")!
    let loggingLevel: LoggingLevel
    
    public init(apiKey: String, loggingLevel: LoggingLevel = .RequestsAndResponses, userAgentIdentifier: String? = nil) {
        
        self.apiKey = apiKey
        self.loggingLevel = loggingLevel
        self.userAgentIdentifier = userAgentIdentifier
    }
}

public class SwiftBomb {
    
    static let framework: SwiftBomb = SwiftBomb()
    var requestFactory: RequestFactory?
    var networkingManager: NetworkingManager?
    
    /// Client apps **must** call this method and pass in an instance of `Configuration`. Typically happens in the application delegate.
    public static func configure(configuration: Configuration) {
        
        let api = SwiftBomb.framework
        
        let authenticationStore = InMemoryAuthenticationStore()
        authenticationStore.apiKey = configuration.apiKey
        api.requestFactory = RequestFactory(configuration: configuration, authenticationStore: authenticationStore)
        api.networkingManager = URLSessionManager(configuration: configuration)
    }
}
