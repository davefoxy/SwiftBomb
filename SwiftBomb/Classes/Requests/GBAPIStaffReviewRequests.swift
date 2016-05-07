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
        
        var request = GBAPIRequest(baseURL: configuration.baseURL, path: "api/reviews", method: .GET, pagination: pagination, sort: sort)
        addAuthentication(&request)
        request.addURLParameter("filter", value: "game:\(game.id)")
        
        return request
    }
}

extension GBGameResource {
    
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
