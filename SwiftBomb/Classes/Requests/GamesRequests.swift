//
//  GamesRequests.swift
//  SwiftBomb
//
//  Created by David Fox on 17/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

extension SwiftBomb {
    
    /**
     Fetches a paginated list of `GameResource` instances. This list can be filtered to a search term, paginated and sorted.
     
     - parameter query: An optional search term used to filter for a particular game.
     - parameter pagination: An optional `PaginationDefinition` to define the limit and offset when paginating results.
     - parameter sort: An optional `SortDefinition` to define how the results should be sorted.
     - parameter fields: An optional array of fields to return in the response. See the available options at http://www.giantbomb.com/api/documentation#toc-0-14. Pass nil to return everything.
     - parameter completion: A closure returning an optional generic `PaginatedResults` object containing the returned `GameResource` objects and pagination information and also, an optional `RequestError` object if the request failed.
     */
    public static func fetchGames(query: String? = nil, pagination: PaginationDefinition? = nil, sort: SortDefinition? = nil, fields: [String]? = nil, completion: (PaginatedResults<GameResource>?, error: RequestError?) -> Void) {
        
        let instance = SwiftBomb.framework
        guard
            let requestFactory = instance.requestFactory,
            let networkingManager = instance.networkingManager else {
                completion(nil, error: .FrameworkConfigError)
                return
        }
        
        let request = requestFactory.gamesRequest(query, pagination: pagination, sort: sort, fields: fields)
        networkingManager.performPaginatedRequest(request, objectType: GameResource.self, completion: completion)
    }
}

extension RequestFactory {
    
    func gamesRequest(query: String? = nil, pagination: PaginationDefinition? = nil, sort: SortDefinition? = nil, fields: [String]? = nil) -> SwiftBombRequest {
        
        var request = SwiftBombRequest(configuration: configuration, path: "games", method: .GET, pagination: pagination, sort: sort, fields: fields)
        addAuthentication(&request)
        
        if let query = query {
            request.addURLParameter("filter", value: "name:\(query)")
        }
        
        return request
    }
}

extension GameResource {
    
    /**
     Fetches extended info for this game. Also re-populates base data in the case where this object is a stub from another parent resource.
     
     - parameter fields: An optional array of fields to return in the response. See the available options at http://www.giantbomb.com/api/documentation#toc-0-14. Pass nil to return everything.
     - parameter completion: A closure containing an optional `RequestError` if the request failed.
     */
    public func fetchExtendedInfo(fields: [String]? = nil, completion: (error: RequestError?) -> Void) {
        
        let api = SwiftBomb.framework
        
        guard
            let networkingManager = api.networkingManager,
            let id = id,
            let request = api.requestFactory?.simpleRequest("game/\(id)/", fields: fields) else {
                completion(error: .FrameworkConfigError)
                return
        }
        
        networkingManager.performDetailRequest(request, resource: self, completion: completion)
    }
}
