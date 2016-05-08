//
//  SearchRequests.swift
//  SwiftBomb
//
//  Created by David Fox on 17/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

extension SwiftBomb {
    
    public static func performSearch(query: String? = nil, resourceTypes: [ResourceType]? = nil, pagination: PaginationDefinition? = nil, sort: SortDefinition? = nil, completion: (searchResults: SearchResults?, error: RequestError?) -> Void) {
        
        let instance = SwiftBomb.framework
        guard
            let requestFactory = instance.requestFactory,
            let networkingManager = instance.networkingManager else {
                completion(searchResults: nil, error: .FrameworkConfigError)
                return
        }
        
        let request = requestFactory.searchRequest(query, resourceTypes: resourceTypes, pagination: pagination, sort: sort)
        networkingManager.performRequest(request) { result in
            
            switch result {
            case .Success(let json):
                
                guard let json = json as? [String: AnyObject] else {
                    return
                }
                
                let searchResults = SearchResults(json: json)
                dispatch_async(dispatch_get_main_queue(), {
                    completion(searchResults: searchResults, error: nil)
                })
                
            case .Error(let error):
                dispatch_async(dispatch_get_main_queue(), {
                    completion(searchResults: nil, error: error)
                })
            }
        }
    }
}

extension RequestFactory {
    
    func searchRequest(query: String? = nil, resourceTypes: [ResourceType]? = nil, pagination: PaginationDefinition? = nil, sort: SortDefinition? = nil) -> Request {
        
        var request = Request(configuration: configuration, path: "search", method: .GET, pagination: pagination, sort: sort)
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