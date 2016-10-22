//
//  URLSessionManager.swift
//  SwiftBomb
//
//  Created by David Fox on 10/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

class URLSessionManager: NetworkingManager {

    var urlSession = URLSession.shared
    var configuration: SwiftBombConfig
    
    init(configuration: SwiftBombConfig) {
        
        self.configuration = configuration
        
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.requestCachePolicy = configuration.urlRequestCachePolicy
        urlSession = URLSession(configuration: sessionConfiguration)
    }
    
    /**
     This is the core method used by most requests to kick off a fetch for paginated information. It uses generics so every request which deals with paginated data can use this one method and the completion enum will give strong typing to the correct struct. It also takes a model object type which conforms to a `PaginationResultsType` so this same method can handle population from JSON to swift objects for any type.
     */
    internal func performPaginatedRequest<T>(_ request: SwiftBombRequest, objectType: T.Type, completion: @escaping (PaginatedResults<T>?, RequestError?) -> Void) {
        
        performRequest(request) { result in
            
            switch result {
            case .success(let json):
                
                guard let json = json as? [String: AnyObject] else {
                    DispatchQueue.main.async(execute: {
                        completion(nil, .responseSerializationError(nil))
                    })
                    return
                }
                
                let paginatedResults = PaginatedResults(json: json, resultsType: objectType.self)
                
                DispatchQueue.main.async(execute: {
                    completion(paginatedResults, nil)
                })
                
            case .error(let error):
                DispatchQueue.main.async(execute: {
                    completion(nil, error)
                })
            }
        }
    }
    
    internal func performDetailRequest<T : ResourceUpdating>(_ request: SwiftBombRequest, resource: T, completion: @escaping (RequestError?) -> Void) {
        
        performRequest(request) { result in
            
            switch result {
            case .success(let json):
                guard
                    let json = json as? [String: AnyObject],
                    let resultJSON = json["results"] as? [String: AnyObject]
                    else {
                        DispatchQueue.main.async(execute: {
                            completion(.responseSerializationError(nil))
                        })
                        return
                }
                
                resource.update(json: resultJSON)
                if resource.extendedInfo != nil {
                    resource.extendedInfo?.update(resultJSON)
                }
                else {
                    resource.extendedInfo = type(of: resource).ExtendedInfoAlias.init(json: resultJSON)
                }
                
                DispatchQueue.main.async(execute: {
                    completion(nil)
                })
                
                
            case .error(let error):
                DispatchQueue.main.async(execute: {
                    completion(error)
                })
            }
        }
    }
    
    internal func performRequest(_ request: SwiftBombRequest, completion: @escaping (RequestResult) -> Void) {
        
        let urlRequest = request.urlRequest()
        
        if configuration.networkingDelegate?.swiftBombShouldPerformRequest(urlRequest) == false {
            
            completion(.success([:] as AnyObject))
            return
        }
        
        configuration.networkingDelegate?.swiftBombWillPerformRequest(urlRequest)
        
        if (configuration.loggingLevel == .requests || configuration.loggingLevel == .requestsAndResponses) {
            print("Making request: \(urlRequest)")
        }
        
        let task = urlSession.dataTask(with: urlRequest, completionHandler: { responseData, urlResponse, error in
            
            if let error = error {
                
                completion(.error(.networkError(error as NSError?)))
                return
            }
            
            if request.responseFormat == .json {
                
                if (self.configuration.loggingLevel == .requestsAndResponses) {
                    print("Response: \(urlResponse)")
                }
                
                do {
                    guard let responseData = responseData else {
                        completion(.error(.responseSerializationError(nil)))
                        return
                    }
                    
                    let json = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as AnyObject
                    if
                        let statusCode = json["status_code"] as? Int,
                        let gbError = ResourceResponseError(rawValue: statusCode) {
                        
                        completion(.error(.requestError(gbError)))
                        return
                    }
                    
                    completion(.success(json))
                }
                catch let error as NSError {
                    completion(.error(.responseSerializationError(error)))
                }
            }
            else {
                
                // xml
                completion(.success(responseData as AnyObject))
            }
        }) 
        
        task.resume()
    }
}
