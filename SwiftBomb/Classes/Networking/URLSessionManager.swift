//
//  URLSessionManager.swift
//  SwiftBomb
//
//  Created by David Fox on 10/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

class URLSessionManager: NetworkingManager {
    
    var urlSession = NSURLSession.sharedSession()
    var configuration: SwiftBombConfig
    
    init(configuration: SwiftBombConfig) {
        
        self.configuration = configuration
        
        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfiguration.requestCachePolicy = configuration.urlRequestCachePolicy
        urlSession = NSURLSession(configuration: sessionConfiguration)
    }
    
    /**
     This is the core method used by most requests to kick off a fetch for paginated information. It uses generics so every request which deals with paginated data can use this one method and the completion enum will give strong typing to the correct struct. It also takes a model object type which conforms to a `PaginationResultsType` so this same method can handle population from JSON to swift objects for any type.
     */
    func performPaginatedRequest<T>(request: SwiftBombRequest, objectType: T.Type, completion: (PaginatedResults<T>?, error: RequestError?) -> Void) {
        
        performRequest(request) { result in
            
            switch result {
            case .Success(let json):
                
                guard let json = json as? [String: AnyObject] else {
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(nil, error: .ResponseSerializationError(nil))
                    })
                    return
                }
                
                let paginatedResults = PaginatedResults(json: json, resultsType: objectType.self)
                
                dispatch_async(dispatch_get_main_queue(), {
                    completion(paginatedResults, error: nil)
                })
                
            case .Error(let error):
                dispatch_async(dispatch_get_main_queue(), {
                    completion(nil, error: error)
                })
            }
        }
    }
    
    func performDetailRequest<T: ResourceUpdating>(request: SwiftBombRequest, resource: T, completion: (error: RequestError?) -> Void) {
        
        performRequest(request) { result in
            
            switch result {
            case .Success(let json):
                guard
                    let json = json as? [String: AnyObject],
                    let resultJSON = json["results"] as? [String: AnyObject]
                    else {
                        dispatch_async(dispatch_get_main_queue(), {
                            completion(error: .ResponseSerializationError(nil))
                        })
                        return
                }
                
                resource.update(resultJSON)
                if resource.extendedInfo != nil {
                    resource.extendedInfo?.update(resultJSON)
                }
                else {
                    resource.extendedInfo = resource.dynamicType.ExtendedInfoAlias.init(json: resultJSON)
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    completion(error: nil)
                })
                
                
            case .Error(let error):
                dispatch_async(dispatch_get_main_queue(), {
                    completion(error: error)
                })
            }
        }
    }
    
    func performRequest(request: SwiftBombRequest, completion: RequestResult -> Void) {
        
        let urlRequest = request.urlRequest()
        
        if (configuration.loggingLevel == .Requests || configuration.loggingLevel == .RequestsAndResponses) {
            print("Making request: \(urlRequest)")
        }
        
        let task = urlSession.dataTaskWithRequest(urlRequest) { responseData, urlResponse, error in
            
            if let error = error {
                
                completion(.Error(.NetworkError(error)))
                return
            }
            
            if request.responseFormat == .JSON {
                
                if (self.configuration.loggingLevel == .RequestsAndResponses) {
                    print("Response: \(urlResponse)")
                }
                
                do {
                    guard let responseData = responseData else {
                        completion(.Error(.ResponseSerializationError(nil)))
                        return
                    }
                    
                    let json = try NSJSONSerialization.JSONObjectWithData(responseData, options: .AllowFragments)
                    if let statusCode = json["status_code"] as? Int, let gbError = ResourceResponseError(rawValue: statusCode) {
                        
                        completion(.Error(.RequestError(gbError)))
                        return
                    }
                    
                    completion(.Success(json))
                }
                catch let error as NSError {
                    completion(.Error(.ResponseSerializationError(error)))
                }
            }
            else {
                
                // xml
                completion(.Success(responseData!))
            }
        }
        
        task.resume()
    }
}
