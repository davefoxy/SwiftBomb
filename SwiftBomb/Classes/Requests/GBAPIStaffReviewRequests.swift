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
     Fetches extended info for this staff review. Also re-populates base data in the case where this object is a stub from another parent resource
     
     - parameter completion: A closure containing an optional `GBAPIError` if the request failed
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