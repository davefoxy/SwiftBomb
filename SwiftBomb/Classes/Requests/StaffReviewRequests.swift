//
//  StaffReviewRequests.swift
//  SwiftBomb
//
//  Created by David Fox on 01/05/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

extension RequestFactory {
    
    func staffReviewRequest(game: GameResource, pagination: PaginationDefinition? = nil, sort: SortDefinition? = nil) -> SwiftBombRequest {
        
        var request = SwiftBombRequest(configuration: configuration, path: "reviews", method: .GET, pagination: pagination, sort: sort)
        addAuthentication(&request)
        
        request.addURLParameter("filter", value: "game:\(game.id)")
        
        return request
    }
}

extension GameResource {
    
    /**
     Fetches a paginated list of `StaffReviewResource` instances for this game.
     
     - parameter completion: A closure returning an optional generic `PaginatedResults` object containing the returned `AccessoryResource` objects and pagination information and also, an optional `RequestError` object if the request failed.
     */
    public func fetchStaffReviews(completion: (PaginatedResults<StaffReviewResource>?, error: RequestError?) -> Void) {
        
        let api = SwiftBomb.framework
        
        guard
            let requestFactory = api.requestFactory,
            let networkingManager = api.networkingManager else {
                completion(nil, error: .FrameworkConfigError)
                return
        }
    
        let request = requestFactory.staffReviewRequest(self)
        networkingManager.performPaginatedRequest(request, objectType: StaffReviewResource.self, completion: completion)
    }
}

extension StaffReviewResource {
    
    /**
     Fetches extended info for this staff review. Also re-populates base data in the case where this object is a stub from another parent resource.
     
     - parameter fields: An optional array of fields to return in the response. See the available options at http://www.giantbomb.com/api/documentation#toc-0-36. Pass nil to return everything.
     - parameter completion: A closure containing an optional `RequestError` if the request failed.
     */
    public func fetchExtendedInfo(fields: [String]? = nil, completion: (error: RequestError?) -> Void) {
        
        let api = SwiftBomb.framework
        
        guard
            let networkingManager = api.networkingManager,
            let id = id,
            let request = api.requestFactory?.simpleRequest("review/\(id)/", fields: fields) else {
                completion(error: .FrameworkConfigError)
                return
        }
        
        networkingManager.performDetailRequest(request, resource: self, completion: completion)
    }
}