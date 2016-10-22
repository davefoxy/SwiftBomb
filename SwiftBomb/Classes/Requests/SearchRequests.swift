//
//  SearchRequests.swift
//  SwiftBomb
//
//  Created by David Fox on 17/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

extension SwiftBomb {
    
    /**
     Performs a generic search on the Giant Bomb API.
     
     Note that this call can take quite a long time so specifying as few resource types as possible is in the best interest of your app's performance. Additionally, the pagination definition used limits how many resources will be returned *for each resource type* and not the amount of resources in total across all types.
     
     - parameter query: A string for which to search upon.
     - parameter resourceTypes: An optional array of `ResourceType`s for which you would like to search. The fewer, the faster.
     - parameter pagination: An optional definition of how to offset and limit the search results.
     - parameter sort: An optional definition of how to sort the resources
     - parameter completion: A closure which contains an instance of `SearchResults` where the results can be found and, optionally, a `RequestError` if the operation failed.
     */
    public static func performSearch(_ query: String? = nil, resourceTypes: [ResourceType]? = nil, pagination: PaginationDefinition? = nil, sort: SortDefinition? = nil, completion: @escaping (_ searchResults: SearchResults?, _ error: RequestError?) -> Void) {
        
        let instance = SwiftBomb.framework
        guard
            let requestFactory = instance.requestFactory,
            let networkingManager = instance.networkingManager else {
                completion(nil, .frameworkConfigError)
                return
        }
        
        let request = requestFactory.searchRequest(query, resourceTypes: resourceTypes, pagination: pagination, sort: sort)
        networkingManager.performRequest(request) { result in
            
            switch result {
            case .success(let json):
                
                guard let json = json as? [String: AnyObject] else {
                    return
                }
                
                let searchResults = SearchResults(json: json)
                DispatchQueue.main.async(execute: {
                    completion(searchResults, nil)
                })
                
            case .error(let error):
                DispatchQueue.main.async(execute: {
                    completion(nil, error)
                })
            }
        }
    }
}

extension RequestFactory {
    
    func searchRequest(_ query: String? = nil, resourceTypes: [ResourceType]? = nil, pagination: PaginationDefinition? = nil, sort: SortDefinition? = nil) -> SwiftBombRequest {
        
        var request = SwiftBombRequest(configuration: configuration, path: "search", method: .get, pagination: pagination, sort: sort)
        addAuthentication(&request)
        
        if let query = query {
            request.addURLParameter("query", value: query)
        }
        
        if let resourceTypes = resourceTypes {
            var resourceTypesField = ""
            for resourceType in resourceTypes {
                resourceTypesField += resourceType.rawValue
                if resourceType != resourceTypes.last {
                    resourceTypesField += ","
                }
            }
            request.addURLParameter("resources", value: resourceTypesField)
        }
        
        request.addURLParameter("field_list", value: "id,name,deck,date_added,date_last_updated,image")
        
        return request
    }
}
