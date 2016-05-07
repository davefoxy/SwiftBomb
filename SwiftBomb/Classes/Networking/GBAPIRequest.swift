//
//  GBAPIRequest.swift
//  GBAPI
//
//  Created by David Fox on 18/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

struct GBAPIRequest {
    
    enum Method: String {
        case POST = "POST"
        case GET = "GET"
    }
    
    enum ResponseFormat {
        case JSON
        case XML
    }
    
    let configuration: GBAPIConfiguration
    let path: String
    let method: Method
    var responseFormat = ResponseFormat.JSON
    private (set) var urlParameters: [String: AnyObject] = [:]
    private (set) var headers: [String: String] = [:]
    private (set) var body: NSData?
    
    init(configuration: GBAPIConfiguration, path: String, method: Method, pagination: PaginationDefinition? = nil, sort: SortDefinition? = nil) {
        
        self.configuration = configuration
        self.path = path
        self.method = method
        
        // Add the content type for all requests
        headers["Content-Type"] = "application/json"
        
        // Optional pagination
        if let pagination = pagination {
            addURLParameter("offset", value: pagination.offset)
            addURLParameter("limit", value: pagination.limit)
        }
        
        // Optional sorting
        if let sort = sort {
            addURLParameter("sort", value: sort.urlParameter())
        }
    }
    
    mutating func addURLParameter(key: String, value: AnyObject) {
        
        urlParameters[key] = value
    }
    
    /// Returns the appropriate NSURLRequest for use in the networking manager
    func urlRequest() -> NSURLRequest {
        
        // Build base URL components
        let components = NSURLComponents()
        components.scheme = configuration.baseAPIURL.scheme
        components.host = configuration.baseAPIURL.host
        components.path = "\(configuration.baseAPIURL.path!)/\(path)"
        
        // Query string
        var query = responseFormat == .JSON ? "format=json&" : "format=xml&"
        for (key, value) in urlParameters {
            query += "\(key)=\(value)&"
        }
        query = query.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "&"))
        components.query = query
        
        // Generate the URL
        let url = components.URL
        
        // Create the URL request
        let urlRequest = NSMutableURLRequest(URL: url!)
        urlRequest.HTTPMethod = method.rawValue
        
        // Headers
        urlRequest.allHTTPHeaderFields = headers
        
        // User agent (optional)
        if let userAgent = configuration.userAgentIdentifier {
            urlRequest.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        }
        
        // Body
        if let body = body {
            urlRequest.HTTPBody = body
        }
        
        return urlRequest
    }
}
