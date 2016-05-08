//
//  URLSessionManager.swift
//  SwiftBomb
//
//  Created by David Fox on 10/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

/**
 An enum returned by network requests which defines the various errors which can occur during communication with the Giant Bomb API.
 */
public enum RequestError: ErrorType {
    
    /// An issue with constructing the required framework components to make the request. Typically occurs when the framework hasn't been initialized with a `Configuration`.
    case FrameworkConfigError
    
    /// An error making the request such as no network signal. Contains a reference to the actual NSError object.
    case NetworkError(NSError?)
    
    /// An error parsing the response from the server. Contains a reference to the actual NSError object.
    case ResponseSerializationError(NSError?)
    
    /// An error specifically returned by the Giant Bomb API. Contains the appropriate enum as defined in `ResourceResponseError`
    case RequestError(ResourceResponseError)
}

/**
 An enum representing the possible error codes the Giant Bomb API can throw back in it's responses.
 */
public enum ResourceResponseError: Int {
    
    /// An invalid API key was provided. Check the API has been initialised with an appropriate `Configuration` and that the provided API key is OK.
    case InvalidAPIKey = 100
    
    /// An invalid resource was requested.
    case ResourceNotFound = 101
    
    /// An issue with the request. If you receive this issue, please file a bug on the Github repo.
    case MalformedRequest = 102
    
    /// An error with the filter type passed in.
    case FilterError = 104
    
    /// A subscriber-only video was requested with a free member's API key.
    case SubscriberOnlyVideo = 105
}

class URLSessionManager: NetworkingManager {
    
    var urlSession = NSURLSession.sharedSession()
    var configuration: Configuration
    
    init(configuration: Configuration) {
        
        self.configuration = configuration
    }
    
    /**
     This is the core method used by most requests to kick off a fetch for paginated information. It uses generics so every request which deals with paginated data can use this one method and the completion enum will give strong typing to the correct struct. It also takes a model object type which conforms to a `PaginationResultsType` so this same method can handle population from JSON to swift objects for any type
     */
    func performPaginatedRequest<T>(request: Request, objectType: T.Type, completion: (PaginatedResults<T>?, error: RequestError?) -> Void) {
        
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
    
    func performDetailRequest<T: ResourceUpdating>(request: Request, resource: T, completion: (error: RequestError?) -> Void) {
        
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
    
    func performRequest(request: Request, completion: RequestResult -> Void) {
        
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
