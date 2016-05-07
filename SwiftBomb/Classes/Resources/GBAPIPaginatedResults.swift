//
//  GBAPIFetchResults.swift
//  GBAPI
//
//  Created by David Fox on 16/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

/**
 A structure which is returned by base framework calls which contains paginated results and the meta data associated with the current page. Uses generics to strongly type the fetched resources to the expected `GBResource` type.
*/
public struct GBAPIPaginatedResults<T: GBResource> {
    
    /// The number of results on this page
    public let number_of_page_results: Int?
    
    /// The number of total results matching the filter conditions specified
    public let number_of_total_results: Int?
    
    /// The value of the offset filter specified, or 0 if not specified
    public let offset: Int?
    
    /// The API version returned by Giant Bomb's API
    public let version: String?
    
    /// Helper to decide whether there's more results or not
    public var hasMoreResults: Bool {
        get {
            guard
                let offset = offset,
                let number_of_page_results = number_of_page_results,
                let number_of_total_results = number_of_total_results else {
                    return true
            }
            return offset + number_of_page_results < number_of_total_results
        }
    }
    
    /// An array of objects generic to the request that made this call. For example, when fetching videos, this will contain an array of Video structs
    public private(set) var resources = [T]()
    
    /// Extended info. Unused for this resource type
    private (set) var extendedInfo: GBUnusedExtendedInfo?
    
    init(json: [String: AnyObject], resultsType: T.Type) {
        
        number_of_page_results = json["number_of_page_results"] as? Int
        number_of_total_results = json["number_of_total_results"] as? Int
        offset = json["offset"] as? Int
        version = json["version"] as? String
        
        // TODO: can use flatMap or something cleaner here instead of checking for array or dict?
        if let resultsArray = json["results"] as? [[String: AnyObject]] {
            for resultJSON in resultsArray {
                let result = resultsType.init(json: resultJSON)
                resources.append(result)
            }
        }
        else if let resultsDictionary = json["results"] as? [String: AnyObject] {
            let result = resultsType.init(json: resultsDictionary)
            resources.append(result)
        }
    }
}
