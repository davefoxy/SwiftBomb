//
//  GBAPICharacterRequests.swift
//  GBAPI
//
//  Created by David Fox on 16/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

extension GBAPI {
    
    /**
     Retrieves a paginated list of `GBCharacterResource` instances. This list can be filtered to a search term, paginated and sorted.
     
     - Parameter query: An optional search term used to filter for a particular character.
     - Parameter pagination: An optional `PaginationDefinition` to define the limit and offset when paginating results.
     - Parameter sort: An optional `SortDefinition` to define how the results should be sorted.
     - Parameter completion: A closure returning an optional generic `GBAPIPaginatedResults` object containing the returned `GBCharacterResource` objects and pagination information and also, an optional `GBAPIError` object if the request failed.
     */
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
        
        var request = GBAPIRequest(configuration: configuration, path: "characters", method: .GET, pagination: pagination, sort: sort)
        addAuthentication(&request)
        
        if let name = name {
            request.addURLParameter("filter", value: "name:\(name)")
        }

        return request
    }
}

extension GBCharacterResource {
    
    /**
     Fetches extended info for this character. Also re-populates base data in the case where this object is a stub from another parent resource
     
     - parameter completion: A closure containing an optional `GBAPIError` if the request failed
     */
    public func fetchExtendedInfo(completion: (error: GBAPIError?) -> Void) {
        
        let api = GBAPI.framework
        
        guard
            let networkingManager = api.networkingManager,
            let id = id,
            let request = api.requestFactory?.simpleRequest("character/\(id)/") else {
                completion(error: .FrameworkConfigError)
                return
        }
        
        networkingManager.performDetailRequest(request, resource: self, completion: completion)
    }
}
