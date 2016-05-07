//
//  GBAPIVideoRequests.swift
//  GBAPI
//
//  Created by David Fox on 16/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

extension GBAPI {
    
    public static func retrieveVideos(query: String?, pagination: PaginationDefinition?, sort: SortDefinition?, completion: (GBAPIPaginatedResults<GBVideoResource>?, error: GBAPIError?) -> Void) {
        
        let instance = GBAPI.framework
        guard
            let requestFactory = instance.requestFactory,
            let networkingManager = instance.networkingManager else {
                assertionFailure("Must initialise the GBAPI with your configuration")
                return
        }
        
        let request = requestFactory.videosRequest(query, pagination: pagination, sort: sort)
        networkingManager.performPaginatedRequest(request, objectType: GBVideoResource.self, completion: completion)
    }
}

extension GBAPIRequestFactory {
    
    func videosRequest(query: String?, pagination: PaginationDefinition?, sort: SortDefinition?) -> GBAPIRequest {
        
        var request = GBAPIRequest(baseURL: configuration.baseURL, path: "api/videos", method: .GET, pagination: pagination, sort: sort)
        addAuthentication(&request)
        
        if let query = query {
            request.addURLParameter("filter", value: "name:\(query)")
        }

        return request
    }
}