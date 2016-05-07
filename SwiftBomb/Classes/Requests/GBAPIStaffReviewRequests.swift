//
//  GBAPIStaffReviewRequests.swift
//  GBAPI
//
//  Created by David Fox on 01/05/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

extension GBAPIRequestFactory {
    
    func staffReviewRequest(game: GBGameResource, pagination: PaginationDefinition? = nil, sort: SortDefinition? = nil) -> GBAPIRequest {
        
        var request = GBAPIRequest(configuration: configuration, path: "reviews", method: .GET, pagination: pagination, sort: sort)
        addAuthentication(&request)
        
        request.addURLParameter("filter", value: "game:\(game.id)")
        
        return request
    }
}

extension GBGameResource {
    
    /**
     Retrieves a paginated list of `GBStaffReviewResource` instances for this game.
     
     - Parameter completion: A closure returning an optional generic `GBAPIPaginatedResults` object containing the returned `GBAccessoryResource` objects and pagination information and also, an optional `GBAPIError` object if the request failed.
     */
    public func fetchStaffReviews(completion: (GBAPIPaginatedResults<GBStaffReviewResource>?, error: GBAPIError?) -> Void) {
        
        let api = GBAPI.framework
        
        guard
            let requestFactory = api.requestFactory,
            let networkingManager = api.networkingManager else {
                completion(nil, error: .FrameworkConfigError)
                return
        }
    
        let request = requestFactory.staffReviewRequest(self)
        networkingManager.performPaginatedRequest(request, objectType: GBStaffReviewResource.self, completion: completion)
    }
}

extension GBStaffReviewResource {
    
    public func fetchExtendedInfo(completion: (error: GBAPIError?) -> Void) {
        
        let api = GBAPI.framework
        
        guard
            let networkingManager = api.networkingManager,
            let id = id,
            let request = api.requestFactory?.simpleRequest("review/\(id)/") else {
                completion(error: .FrameworkConfigError)
                return
        }
        
        networkingManager.performDetailRequest(request, resource: self, completion: completion)
    }
}