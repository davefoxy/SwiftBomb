//
//  StaffReviewRequests.swift
//  SwiftBomb
//
//  Created by David Fox on 01/05/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

extension RequestFactory {
    
    func staffReviewRequest(game: GameResource, pagination: PaginationDefinition? = nil, sort: SortDefinition? = nil) -> Request {
        
        var request = Request(configuration: configuration, path: "reviews", method: .GET, pagination: pagination, sort: sort)
        addAuthentication(&request)
        
        request.addURLParameter("filter", value: "game:\(game.id)")
        
        return request
    }
}

extension GameResource {
    
    /**
     Retrieves a paginated list of `StaffReviewResource` instances for this game.
     
     - Parameter completion: A closure returning an optional generic `PaginatedResults` object containing the returned `AccessoryResource` objects and pagination information and also, an optional `RequestError` object if the request failed.
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
    
    public func fetchExtendedInfo(completion: (error: RequestError?) -> Void) {
        
        let api = SwiftBomb.framework
        
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