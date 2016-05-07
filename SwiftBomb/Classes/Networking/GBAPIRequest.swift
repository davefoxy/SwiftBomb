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
    
    let baseURL: NSURL
    let path: String
    let method: Method
    var responseFormat = ResponseFormat.JSON
    private (set) var urlParameters: [String: AnyObject] = [:]
    private (set) var headers: [String: String] = [:]
    private (set) var body: NSData?
    
    init(baseURL: NSURL, path: String, method: Method, pagination: PaginationDefinition? = nil, sort: SortDefinition? = nil) {
        
        self.baseURL = baseURL
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
        
        let components = NSURLComponents(string: path)
        components?.scheme = "http"
        components?.host = "www.giantbomb.com" // TODO: rework and use from baseURL
        components?.path = "/\(path)"
        
        var query = responseFormat == .JSON ? "format=json&" : ""
        for (key, value) in urlParameters {
            query += "\(key)=\(value)&"
        }
        query = query.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "&"))
        components?.query = query
        
        let url = components?.URL
        
        let urlRequest = NSMutableURLRequest(URL: url!)
        urlRequest.HTTPMethod = method.rawValue
        
        urlRequest.allHTTPHeaderFields = headers
        
        if let body = body {
            urlRequest.HTTPBody = body
        }
        
        return urlRequest
    }
}
