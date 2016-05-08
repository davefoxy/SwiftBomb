//
//  GameReleasesRequests.swift
//  SwiftBomb
//
//  Created by David Fox on 07/05/2016.
//
//

import Foundation

extension SwiftBomb {
    
    /**
     Fetches a paginated list of `GameReleaseResource` instances. This list can be filtered to a search term, paginated and sorted.
     
     - parameter query: An optional search term used to filter for a particular game release.
     - parameter pagination: An optional `PaginationDefinition` to define the limit and offset when paginating results.
     - parameter sort: An optional `SortDefinition` to define how the results should be sorted.
     - parameter completion: A closure returning an optional generic `PaginatedResults` object containing the returned `GameReleaseResource` objects and pagination information and also, an optional `RequestError` object if the request failed.
     */
    public static func fetchReleases(query: String? = nil, pagination: PaginationDefinition? = nil, sort: SortDefinition? = nil, completion: (PaginatedResults<GameReleaseResource>?, error: RequestError?) -> Void) {
        
        let instance = SwiftBomb.framework
        guard
            let requestFactory = instance.requestFactory,
            let networkingManager = instance.networkingManager else {
                completion(nil, error: .FrameworkConfigError)
                return
        }
        
        let request = requestFactory.gameReleasesRequest(query, pagination: pagination, sort: sort)
        networkingManager.performPaginatedRequest(request, objectType: GameReleaseResource.self, completion: completion)
    }
}

extension RequestFactory {
    
    func gameReleasesRequest(query: String? = nil, pagination: PaginationDefinition? = nil, sort: SortDefinition? = nil) -> Request {
        
        var request = Request(configuration: configuration, path: "releases", method: .GET, pagination: pagination, sort: sort)
        addAuthentication(&request)
        
        if let query = query {
            request.addURLParameter("filter", value: "name:\(query)")
        }
        
        return request
    }
}

extension GameReleaseResource {
    
    /**
     Fetches extended info for this release. Also re-populates base data in the case where this object is a stub from another parent resource.
     
     - parameter completion: A closure containing an optional `RequestError` if the request failed.
     */
    public func fetchExtendedInfo(completion: (error: RequestError?) -> Void) {
        
        let api = SwiftBomb.framework
        
        guard
            let networkingManager = api.networkingManager,
            let id = id,
            let request = api.requestFactory?.simpleRequest("release/\(id)/") else {
                completion(error: .FrameworkConfigError)
                return
        }
        
        networkingManager.performDetailRequest(request, resource: self, completion: completion)
    }
}
