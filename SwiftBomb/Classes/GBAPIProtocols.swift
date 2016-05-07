//
//  GBAPIProtocols.swift
//  GBAPI
//
//  Created by David Fox on 01/05/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

protocol GBAPIAuthenticationStore {
    
    var apiKey: String { get set }
}

protocol GBAPINetworkingManager {
    
    var configuration: GBAPIConfiguration { get }
    
    func performPaginatedRequest<T>(request: GBAPIRequest, objectType: T.Type, completion: (GBAPIPaginatedResults<T>?, error: GBAPIError?) -> Void)
    
    func performDetailRequest<T: GBResourceUpdating>(request: GBAPIRequest, resource: T, completion: (error: GBAPIError?) -> Void)
    
    func performRequest(request: GBAPIRequest, completion: GBAPIRequestResult<AnyObject> -> Void)
}
