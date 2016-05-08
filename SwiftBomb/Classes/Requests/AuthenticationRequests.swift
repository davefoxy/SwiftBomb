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
    
    func authenticationRegCodeRequest() -> Request {
        
        var request = Request(configuration: configuration, path: "apple-tv/get-code", method: .GET)
        request.responseFormat = .XML
        request.addURLParameter("deviceID", value: "XXX")
        
        return request
    }
    
    func authenticationAPIKeyRequest(regCode: String) -> Request {
        
        var request = Request(configuration: configuration, path: "apple-tv/get-result", method: .GET)
        request.addURLParameter("deviceID", value: "XXX")
        request.addURLParameter("partner", value: "apple-tv")
        request.addURLParameter("regCode", value: regCode)
        
        return request
    }
}