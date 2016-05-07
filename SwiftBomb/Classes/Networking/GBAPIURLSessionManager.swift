//
//  GBAPIURLSessionManager.swift
//  GBAPI
//
//  Created by David Fox on 10/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

public enum GBAPIRequestResult<T> {
    case Success(T)
    case Error(GBAPIError)
}

public enum GBAPIError: ErrorType {
    case FrameworkConfigError
    case NetworkError(NSError?)
    case ResponseSerializationError(NSError?)
    case RequestError(GBAPIResourceRequestError)
}

public enum GBAPIResourceRequestError: Int {
    case InvalidAPIKey = 100
    case ResourceNotFound = 101
    case MalformedRequest = 102
    case FilterError = 104
    case SubscriberOnlyVideo = 105
}

class GBAPIURLSessionManager: GBAPINetworkingManager {
    
    var configuration: GBAPIConfiguration
    
    init(configuration: GBAPIConfiguration) {
        
        self.configuration = configuration
    }
    
    /**
     This is the core method used by most requests to kick off a fetch for paginated information. It uses generics so every request which deals with paginated data can use this one method and the completion enum will give strong typing to the correct struct. It also takes a model object type which conforms to a GBAPIPaginationResultsType so this same method can handle population from JSON to swift objects for any type
     */
    func performPaginatedRequest<T>(request: GBAPIRequest, objectType: T.Type, completion: (GBAPIPaginatedResults<T>?, error: GBAPIError?) -> Void) {
        
        performRequest(request) { result in
            
            switch result {
            case .Success(let json):
                
                guard let json = json as? [String: AnyObject] else {
                    dispatch_async(dispatch_get_main_queue(), {
                        completion(nil, error: .ResponseSerializationError(nil))
                    })
                    return
                }
                
                let paginatedResults = GBAPIPaginatedResults(json: json, resultsType: objectType.self)
                
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
    
    func performDetailRequest<T: GBResourceUpdating>(request: GBAPIRequest, resource: T, completion: (error: GBAPIError?) -> Void) {
        
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
                resource.extendedInfo = resource.dynamicType.ExtendedInfoAlias.init(json: resultJSON)
                
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
    
    func performRequest(request: GBAPIRequest, completion: GBAPIRequestResult<AnyObject> -> Void) {
        
        print("Making request: \(request.urlRequest())")
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request.urlRequest()) { responseData, urlResponse, error in
            
            if let error = error {
                
                completion(.Error(.NetworkError(error)))
                return
            }
            
            if request.responseFormat == .JSON {
                
                do {
                    print("ERROR: \(error)")
                    guard let responseData = responseData else {
                        completion(.Error(.ResponseSerializationError(nil)))
                        return
                    }
                    
                    let json = try NSJSONSerialization.JSONObjectWithData(responseData, options: .AllowFragments)
                    if let statusCode = json["status_code"] as? Int, let gbError = GBAPIResourceRequestError(rawValue: statusCode) {
                        
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
