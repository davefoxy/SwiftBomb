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
        case json
        case xml
    }
    
    enum BaseURLType {
        case api
        case site
    }
    
    let configuration: SwiftBombConfig
    let path: String
    let method: Method
    var responseFormat = ResponseFormat.json
    var baseURLType: BaseURLType = .api
    fileprivate (set) var urlParameters: [String: AnyObject] = [:]
    fileprivate (set) var headers: [String: String] = [:]
    fileprivate (set) var body: Data?
    
    init(configuration: SwiftBombConfig, path: String, method: Method, pagination: PaginationDefinition? = nil, sort: SortDefinition? = nil, fields: [String]? = nil) {
        
        self.configuration = configuration
        self.path = path
        self.method = method
        
        // Add the content type for all requests
        headers["Content-Type"] = "application/json"
        
        // Optional pagination
        if let pagination = pagination {
            addURLParameter("offset", value: "\(pagination.offset)")
            addURLParameter("limit", value: "\(pagination.limit)")
        }
        
        // Optional sorting
        if let sort = sort {
            addURLParameter("sort", value: sort.urlParameter())
        }
        
        // Optional fields
        addFields(fields)
    }
    
    mutating func addURLParameter(_ key: String, value: String) {
        
        urlParameters[key] = value as AnyObject
    }
    
    mutating func addFields(_ fields: [String]?) {
        
        if let fields = fields {
            
            var fieldsString = fields.joined(separator: ",")
            if fieldsString.range(of: "id") == nil {
                fieldsString += ",id"
            }
            
            urlParameters["field_list"] = fieldsString as AnyObject?
        }
    }
    
    /// Returns the appropriate NSURLRequest for use in the networking manager
    func urlRequest() -> URLRequest {
        
        // Build base URL components
        var components = URLComponents()
        let baseURL = baseURLType == .api ? configuration.baseAPIURL : configuration.baseSiteURL
        components.scheme = baseURL.scheme
        components.host = baseURL.host
        components.path = "\(baseURL.path)/\(path)"
        
        // Query string
        var query = responseFormat == .json ? "format=json&" : "format=xml&"
        for (key, value) in urlParameters {
            query += "\(key)=\(value)&"
        }
        query = query.trimmingCharacters(in: CharacterSet(charactersIn: "&"))
        components.query = query
        
        // Generate the URL
        let url = components.url
        
        // Create the URL request
        let urlRequest = NSMutableURLRequest(url: url!)
        urlRequest.httpMethod = method.rawValue
        
        // Headers
        urlRequest.allHTTPHeaderFields = headers
        
        // User agent (optional)
        if let userAgent = configuration.userAgentIdentifier {
            urlRequest.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        }
        
        // Body
        if let body = body {
            urlRequest.httpBody = body
        }
        
        return urlRequest as URLRequest
    }
}
