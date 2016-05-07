//
//  GBAPIAuthenticationRequests.swift
//  GBAPI
//
//  Created by David Fox on 17/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

extension GBAPI {
    
    static func createAuthenticationSession() -> GBAPIAuthenticationSession {
        
        let instance = GBAPI.framework
        let authenticationSession = GBAPIAuthenticationSession(requestFactory: instance.requestFactory!, networkingManager: instance.networkingManager!, authenticationStore: (instance.requestFactory?.authenticationStore)!)
        return authenticationSession
    }
}

extension GBAPIRequestFactory {
    
    func authenticationRegCodeRequest() -> GBAPIRequest {
        
        var request = GBAPIRequest(baseURL: configuration.baseURL, path: "apple-tv/get-code", method: .GET)
        request.responseFormat = .XML
        request.addURLParameter("deviceID", value: "XXX") // TODO: real value
        
        return request
    }
    
    func authenticationAPIKeyRequest(regCode: String) -> GBAPIRequest {
        
        var request = GBAPIRequest(baseURL: configuration.baseURL, path: "apple-tv/get-result", method: .GET)
        request.addURLParameter("deviceID", value: "XXX") // TODO: real value
        request.addURLParameter("partner", value: "apple-tv")
        request.addURLParameter("regCode", value: regCode)
        
        return request
    }
}