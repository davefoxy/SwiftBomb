//
//  GBAPIRequestFactory.swift
//  GBAPI
//
//  Created by David Fox on 10/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

// MARK: Pagination and Sorting Definitions
public typealias PaginationDefinition = (offset: Int, limit: Int)

public struct SortDefinition {
    
    let field: String
    let direction: SortDirection
    
    public enum SortDirection: String {
        case Ascending = "asc"
        case Descending = "desc"
    }
    
    public init(field: String, direction: SortDirection) {
        self.field = field
        self.direction = direction
    }
    
    func urlParameter() -> String {
        return "\(field):\(direction.rawValue)"
    }
}

final class GBAPIRequestFactory {
    
    let configuration: GBAPIConfiguration
    let authenticationStore: GBAPIAuthenticationStore
    
    init(configuration: GBAPIConfiguration, authenticationStore: GBAPIAuthenticationStore) {
        
        self.configuration = configuration
        self.authenticationStore = authenticationStore
    }
    
    func addAuthentication(inout request: GBAPIRequest) {
        
        request.addURLParameter("api_key", value: authenticationStore.apiKey)
    }
    
    // MARK: Base requests
    func simpleRequest(path: String) -> GBAPIRequest {
        
        var request = GBAPIRequest(baseURL: configuration.baseURL, path: path, method: .GET)
        addAuthentication(&request)
        
        return request
    }
}
