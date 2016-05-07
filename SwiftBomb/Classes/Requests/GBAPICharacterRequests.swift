//
//  GBAPICharacterRequests.swift
//  GBAPI
//
//  Created by David Fox on 16/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

extension GBAPI {
    
    public static func retrieveCharacters(name: String? = nil, pagination: PaginationDefinition?, sort: SortDefinition?, completion: (GBAPIPaginatedResults<GBCharacterResource>?, error: GBAPIError?) -> Void) {
        
        let instance = GBAPI.framework
        guard
            let requestFactory = instance.requestFactory,
            let networkingManager = instance.networkingManager else {
                assertionFailure("Must initialise the GBAPI with your configuration")
                return
        }
        
        let request = requestFactory.charactersRequest(name, pagination: pagination, sort: sort)
        networkingManager.performPaginatedRequest(request, objectType: GBCharacterResource.self, completion: completion)
    }
}

extension GBAPIRequestFactory {
    
    func charactersRequest(name: String? = nil, pagination: PaginationDefinition? = nil, sort: SortDefinition? = nil) -> GBAPIRequest {
        
        var request = GBAPIRequest(baseURL: configuration.baseURL, path: "api/characters/", method: .GET, pagination: pagination, sort: sort)
        addAuthentication(&request)
        if let name = name {
            request.addURLParameter("filter", value: "name:\(name)")
        }

        return request
    }
}

extension GBCharacterResource {
    
    public func fetchExtendedInfo(completion: (error: GBAPIError?) -> Void) {
        
        let api = GBAPI.framework
        
        guard
            let networkingManager = api.networkingManager,
            let id = id,
            let request = api.requestFactory?.simpleRequest("api/character/\(id)/") else {
                completion(error: .FrameworkConfigError)
                return
        }
        
        networkingManager.performDetailRequest(request, resource: self, completion: completion)
    }
}
