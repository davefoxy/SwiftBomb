//
//  PeopleRequests.swift
//  SwiftBomb
//
//  Created by David Fox on 25/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

extension SwiftBomb {
    
    /**
     Retrieves a paginated list of `PersonResource` instances. This list can be filtered to a search term, paginated and sorted.
     
     - Parameter query: An optional search term used to filter for a particular person.
     - Parameter pagination: An optional `PaginationDefinition` to define the limit and offset when paginating results.
     - Parameter sort: An optional `SortDefinition` to define how the results should be sorted.
     - Parameter completion: A closure returning an optional generic `PaginatedResults` object containing the returned `PersonResource` objects and pagination information and also, an optional `RequestError` object if the request failed.
     */
    public static func retrievePeople(query: String? = nil, pagination: PaginationDefinition? = nil, sort: SortDefinition? = nil, completion: (PaginatedResults<PersonResource>?, error: RequestError?) -> Void) {
        
        let instance = SwiftBomb.framework
        guard
            let requestFactory = instance.requestFactory,
            let networkingManager = instance.networkingManager else {
                completion(nil, error: .FrameworkConfigError)
                return
        }
        
        let request = requestFactory.peopleRequest(query, pagination: pagination, sort: sort)
        networkingManager.performPaginatedRequest(request, objectType: PersonResource.self, completion: completion)
    }
}

extension RequestFactory {
    
    func peopleRequest(query: String? = nil, pagination: PaginationDefinition? = nil, sort: SortDefinition? = nil) -> Request {
        
        var request = Request(configuration: configuration, path: "people", method: .GET, pagination: pagination, sort: sort)
        addAuthentication(&request)
        
        if let query = query {
            request.addURLParameter("filter", value: "name:\(query)")
        }
        
        return request
    }
}

extension PersonResource {
    
    /**
     Fetches extended info for this person. Also re-populates base data in the case where this object is a stub from another parent resource
     
     - parameter completion: A closure containing an optional `RequestError` if the request failed
     */
    public func fetchExtendedInfo(completion: (error: RequestError?) -> Void) {
        
        let api = SwiftBomb.framework
        
        guard
            let networkingManager = api.networkingManager,
            let id = id,
            let request = api.requestFactory?.simpleRequest("person/\(id)/") else {
                completion(error: .FrameworkConfigError)
                return
        }
        
        networkingManager.performDetailRequest(request, resource: self, completion: completion)
    }
}
