//
//  GBAPIAccessoriesRequests.swift
//  GBAPI
//
//  Created by David Fox on 25/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

extension GBAPI {
    
    /**
     Retrieves a paginated list of `GBAccessoryResource` instances. This list can be filtered to a search term, paginated and sorted.
     
     - Parameter query: An optional search term used to filter for a particular accessory.
     - Parameter pagination: An optional `PaginationDefinition` to define the limit and offset when paginating results.
     - Parameter sort: An optional `SortDefinition` to define how the results should be sorted.
     - Parameter completion: A closure returning an optional generic `GBAPIPaginatedResults` object containing the returned `GBAccessoryResource` objects and pagination information and also, an optional `GBAPIError` object if the request failed.
     */
    public static func retrieveAccessories(query: String? = nil, pagination: PaginationDefinition? = nil, sort: SortDefinition? = nil, completion: (GBAPIPaginatedResults<GBAccessoryResource>?, error: GBAPIError?) -> Void) {
        
        let instance = GBAPI.framework
        guard
            let requestFactory = instance.requestFactory,
            let networkingManager = instance.networkingManager else {
                assertionFailure("Must initialise the GBAPI with your configuration")
                return
        }

        let request = requestFactory.accessoriesRequest(query, pagination: pagination, sort: sort)
        networkingManager.performPaginatedRequest(request, objectType: GBAccessoryResource.self, completion: completion)
    }
}

extension GBAPIRequestFactory {
    
    func accessoriesRequest(query: String? = nil, pagination: PaginationDefinition? = nil, sort: SortDefinition? = nil) -> GBAPIRequest {
        
        var request = GBAPIRequest(configuration: configuration, path: "accessories", method: .GET, pagination: pagination, sort: sort)
        addAuthentication(&request)
        
        if let query = query {
            request.addURLParameter("filter", value: "name:\(query)")
        }
        
        return request
    }
}

extension GBAccessoryResource {
    
    /**
     Fetches extended info for this accessory. Also re-populates base data in the case where this object is a stub from another parent resource
     
     - parameter completion: A closure containing an optional `GBAPIError` if the request failed
     */
    public func fetchExtendedInfo(completion: (error: GBAPIError?) -> Void) {
        
        let api = GBAPI.framework
        
        guard
            let networkingManager = api.networkingManager,
            let id = id,
            let request = api.requestFactory?.simpleRequest("accessory/\(id)/") else {
                completion(error: .FrameworkConfigError)
                return
        }
        
        networkingManager.performDetailRequest(request, resource: self, completion: completion)
    }
}
