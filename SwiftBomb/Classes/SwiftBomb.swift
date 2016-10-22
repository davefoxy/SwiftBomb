//
//  SwiftBomb.swift
//  SwiftBomb
//
//  Created by David Fox on 10/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

/**
 A singleton from which SwiftBomb does it's setup. Ensure to configure the framework on app startup by calling `configure(_:)` before attempting to make any requests.
 */
open class SwiftBomb {
    
    static let framework: SwiftBomb = SwiftBomb()
    var requestFactory: RequestFactory?
    var networkingManager: NetworkingManager?
    
    /// Client apps **must** call this method and pass in an instance of `SwiftBombConfig`. Typically happens in the application delegate.
    open static func configure(_ configuration: SwiftBombConfig) {
        
        let api = SwiftBomb.framework
        
        let authenticationStore = InMemoryAuthenticationStore()
        authenticationStore.apiKey = configuration.apiKey
        api.requestFactory = RequestFactory(configuration: configuration, authenticationStore: authenticationStore)
        api.networkingManager = URLSessionManager(configuration: configuration)
    }
}
