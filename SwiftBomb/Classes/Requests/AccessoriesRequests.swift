//
//  AccessoriesRequests.swift
//  SwiftBomb
//
//  Created by David Fox on 25/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

extension SwiftBomb {
    
    /**
     Fetches a paginated list of `AccessoryResource` instances. This list can be filtered to a search term, paginated and sorted.
     
     - parameter query: An optional search term used to filter for a particular accessory.
     - parameter pagination: An optional `PaginationDefinition` to define the limit and offset when paginating results.
     - parameter sort: An optional `SortDefinition` to define how the results should be sorted.
     - parameter fields: An optional array of fields to return in the response. See the available options at http://www.giantbomb.com/api/documentation#toc-0-2. Pass nil to return everything.
     - parameter completion: A closure returning an optional generic `PaginatedResults` object containing the returned `AccessoryResource` objects and pagination information and also, an optional `RequestError` object if the request failed.
     */
    public static func fetchAccessories(_ query: String? = nil, pagination: PaginationDefinition? = nil, sort: SortDefinition? = nil, fields: [String]? = nil, completion: @escaping (PaginatedResults<AccessoryResource>?, _ error: RequestError?) -> Void) {
        
        let instance = SwiftBomb.framework
        guard
            let requestFactory = instance.requestFactory,
            let networkingManager = instance.networkingManager else {
                completion(nil, .frameworkConfigError)
                return
        }

        let request = requestFactory.accessoriesRequest(query, pagination: pagination, sort: sort, fields: fields)
        networkingManager.performPaginatedRequest(request, objectType: AccessoryResource.self, completion: completion)
    }
}

extension RequestFactory {
    
    func accessoriesRequest(_ query: String? = nil, pagination: PaginationDefinition? = nil, sort: SortDefinition? = nil, fields: [String]?) -> SwiftBombRequest {
        
        var request = SwiftBombRequest(configuration: configuration, path: "accessories", method: .get, pagination: pagination, sort: sort, fields: fields)
        addAuthentication(&request)
        
        if let query = query {
            request.addURLParameter("filter", value: "name:\(query)")
        }
        
        return request
    }
}

extension AccessoryResource {
    
    /**
     Fetches extended info for this accessory. Also re-populates base data in the case where this object is a stub from another parent resource.
     
     - parameter fields: An optional array of fields to return in the response. See the available options at http://www.giantbomb.com/api/documentation#toc-0-2. Pass nil to return everything.
     - parameter completion: A closure containing an optional `RequestError` if the request failed.
     */
    public func fetchExtendedInfo(_ fields: [String]? = nil, completion: @escaping (_ error: RequestError?) -> Void) {
        
        let api = SwiftBomb.framework
        
        guard
            let networkingManager = api.networkingManager,
            let id = id,
            let request = api.requestFactory?.simpleRequest("accessory/\(id)/", fields: fields) else {
                completion(.frameworkConfigError)
                return
        }
        
        networkingManager.performDetailRequest(request, resource: self, completion: completion)
    }
}
