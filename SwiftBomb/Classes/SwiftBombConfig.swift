//
//  SwiftBombConfig.swift
//  SwiftBomb
//
//  Created by David Fox on 08/05/2016.
//
//

import Foundation

/**
 A struct which the client app is required to instantiate and pass into the API instance containing the user's API key, optional level of logging and user agent.
 */
public struct SwiftBombConfig {
    
    /// An enum specifying the various levels of logging the framework should make. `None` should be used in production.
    public enum LoggingLevel {
        
        /// No logs will be made by the framework.
        case none
        
        /// Requests will be logged when being sent to the Giant Bomb API.
        case requests
        
        /// Requests and the resulting response headers will be logged.
        case requestsAndResponses
    }
    
    let apiKey: String
    let userAgentIdentifier: String?
    let baseAPIURL = URL(string: "http://www.giantbomb.com/api")!
    let baseSiteURL = URL(string: "http://www.giantbomb.com")!
    let loggingLevel: LoggingLevel
    let networkingDelegate: SwiftBombNetworkingDelegate?
    let urlRequestCachePolicy: NSURLRequest.CachePolicy
    
    /**
     Designated initializer for creating a configuration object.
     
     - parameter apiKey: Your API key for Giant Bomb. Get one from www.giantbomb.com/api.
     - parameter loggingLevel: Optional level of logging SwiftBomb should make. See `LoggingLevel` for options.
     - parameter userAgentIdentifier: Optional user agent to provide when making requests to the Giant Bomb API.
     - parameter networkingDelegate: Optional object conforming to `SwiftBombNetworkingDelegate` which allows inspection and denial of requests being made by the library.
     - parameter urlRequestCachePolicy: Optionally define how you would like the internal NSURLSession to handle caching. Defaults to the default policy of `UserProtocolCachePolicy`.
     */
    public init(apiKey: String, loggingLevel: LoggingLevel = .requestsAndResponses, userAgentIdentifier: String? = nil, networkingDelegate: SwiftBombNetworkingDelegate? = nil, urlRequestCachePolicy: NSURLRequest.CachePolicy = .useProtocolCachePolicy) {
        
        self.apiKey = apiKey
        self.loggingLevel = loggingLevel
        self.userAgentIdentifier = userAgentIdentifier
        self.networkingDelegate = networkingDelegate
        self.urlRequestCachePolicy = urlRequestCachePolicy
    }
}
