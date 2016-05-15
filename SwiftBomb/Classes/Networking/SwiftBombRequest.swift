//
//  SwiftBombRequest.swift
//  SwiftBomb
//
//  Created by David Fox on 18/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

struct SwiftBombRequest {
    
    enum Method: String {
        case POST = "POST"
        case GET = "GET"
    }
    
    enum ResponseFormat {
        case JSON
        case XML
    }
    
    let configuration: SwiftBombConfig
    let path: String
    let method: Method
    var responseFormat = ResponseFormat.JSON
    private (set) var urlParameters: [String: AnyObject] = [:]
    private (set) var headers: [String: String] = [:]
    private (set) var body: NSData?
    
    init(configuration: SwiftBombConfig, path: String, method: Method, pagination: PaginationDefinition? = nil, sort: SortDefinition? = nil, fields: [String]? = nil) {
        
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
        
        // Optional fields
        addFields(fields)
    }
    
    mutating func addURLParameter(key: String, value: AnyObject) {
        
        urlParameters[key] = value
    }
    
    mutating func addFields(fields: [String]?) {
        
        if let fields = fields {
            
            var fieldsString = fields.joinWithSeparator(",")
            if fieldsString.rangeOfString("id") == nil {
                fieldsString += ",id"
            }
            
            urlParameters["field_list"] = fieldsString
        }
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
