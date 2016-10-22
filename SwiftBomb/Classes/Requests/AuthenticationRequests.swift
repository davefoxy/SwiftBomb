//
//  AuthenticationRequests.swift
//  SwiftBomb
//
//  Created by David Fox on 17/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

extension SwiftBomb {
    
    static func createAuthenticationSession() -> AuthenticationSession {
        
        let instance = SwiftBomb.framework
        let authenticationSession = AuthenticationSession(requestFactory: instance.requestFactory!, networkingManager: instance.networkingManager!, authenticationStore: (instance.requestFactory?.authenticationStore)!)
        return authenticationSession
    }
}

extension RequestFactory {
    
    func authenticationRegCodeRequest() -> SwiftBombRequest {
        
        var request = SwiftBombRequest(configuration: configuration, path: "apple-tv/get-code", method: .get)
        request.responseFormat = .xml
        request.addURLParameter("deviceID", value: "XXX")
        
        return request
    }
    
    func authenticationAPIKeyRequest(_ regCode: String) -> SwiftBombRequest {
        
        var request = SwiftBombRequest(configuration: configuration, path: "apple-tv/get-result", method: .get)
        request.addURLParameter("deviceID", value: "XXX")
        request.addURLParameter("partner", value: "apple-tv")
        request.addURLParameter("regCode", value: regCode)
        
        return request
    }
}
