//
//  Configuration.swift
//  Pods
//
//  Created by David Fox on 08/05/2016.
//
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
    
    /**
     Designated initializer for creating a configuration object.
     
     - parameter apiKey: Your API key for Giant Bomb. Get one from www.giantbomb.com/api.
     - parameter loggingLevel: Optional level of logging SwiftBomb should make. See `LoggingLevel` for options.
     - parameter userAgentIdentifier: Optional user agent to provide when making requests to the Giant Bomb API.
     */
    public init(apiKey: String, loggingLevel: LoggingLevel = .RequestsAndResponses, userAgentIdentifier: String? = nil) {
        
        self.apiKey = apiKey
        self.loggingLevel = loggingLevel
        self.userAgentIdentifier = userAgentIdentifier
    }
}
