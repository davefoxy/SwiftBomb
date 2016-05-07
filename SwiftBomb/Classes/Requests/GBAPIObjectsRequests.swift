//
//  GBAPIObjectsRequests.swift
//  GBAPI
//
//  Created by David Fox on 25/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

extension GBAPI {
    
    /**
     Retrieves a paginated list of `GBObjectResource` instances. This list can be filtered to a search term, paginated and sorted.
     
     - Parameter query: An optional search term used to filter for a particular object.
     - Parameter pagination: An optional `PaginationDefinition` to define the limit and offset when paginating results.
     - Parameter sort: An optional `SortDefinition` to define how the results should be sorted.
     - Parameter completion: A closure returning an optional generic `GBAPIPaginatedResults` object containing the returned `GBObjectResource` objects and pagination information and also, an optional `GBAPIError` object if the request failed.
     */
    public static func retrieveObjects(query: String? = nil, pagination: PaginationDefinition? = nil, sort: SortDefinition? = nil, completion: (GBAPIPaginatedResults<GBObjectResource>?, error: GBAPIError?) -> Void) {
        
        let instance = GBAPI.framework
        guard
            let requestFactory = instance.requestFactory,
            let networkingManager = instance.networkingManager else {
                assertionFailure("Must initialise the GBAPI with your configuration")
                return
        }
        
        let request = requestFactory.objectRequest(query, pagination: pagination, sort: sort)
        networkingManager.performPaginatedRequest(request, objectType: GBObjectResource.self, completion: completion)
    }
}

extension GBAPIRequestFactory {
    
    /**
     Fetches extended info for this object. Also re-populates base data in the case where this object is a stub from another parent resource
     
     - parameter completion: A closure containing an optional `GBAPIError` if the request failed
     */
    func objectRequest(query: String? = nil, pagination: PaginationDefinition? = nil, sort: SortDefinition? = nil) -> GBAPIRequest {
        
        var request = GBAPIRequest(configuration: configuration, path: "objects", method: .GET, pagination: pagination, sort: sort)
        addAuthentication(&request)
        
        if let query = query {
            request.addURLParameter("filter", value: "name:\(query)")
        }
        
        return request
    }
}

extension GBObjectResource {
    
    public func fetchExtendedInfo(completion: (error: GBAPIError?) -> Void) {
        
        let api = GBAPI.framework
        
        guard
            let networkingManager = api.networkingManager,
            let id = id,
            let request = api.requestFactory?.simpleRequest("object/\(id)/") else {
                completion(error: .FrameworkConfigError)
                return
        }
        
        networkingManager.performDetailRequest(request, resource: self, completion: completion)
    }
}
