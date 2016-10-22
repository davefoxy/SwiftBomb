//
//  StaffReviewRequests.swift
//  SwiftBomb
//
//  Created by David Fox on 01/05/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

extension RequestFactory {
    
    func staffReviewRequest(_ game: GameResource, fields: [String]? = nil) -> SwiftBombRequest {
        
        var request = SwiftBombRequest(configuration: configuration, path: "reviews", method: .get, pagination: nil, sort: nil, fields: fields)
        addAuthentication(&request)
        
        if let gameID = game.id {
            request.addURLParameter("filter", value: "game:\(gameID)")
        }
        
        return request
    }
}

extension GameResource {
    
    /**
     Fetches the Giant Bomb staff review (if one was written) for this game.
     
     - parameter fields: An optional array of fields to return in the response. See the available options at http://www.giantbomb.com/api/documentation#toc-0-36. Pass nil to return everything.
     - parameter completion: A closure containing an optional `RequestError` if the request failed.
     */
    public func fetchStaffReview(_ fields: [String]? = nil, completion: @escaping (_ error: RequestError?) -> Void) -> Void {
        
        let api = SwiftBomb.framework
        
        guard
            let networkingManager = api.networkingManager,
            let request = api.requestFactory?.staffReviewRequest(self, fields: fields) else {
                completion(.frameworkConfigError)
                return
        }
        
        networkingManager.performRequest(request) { [weak self] result in
            
            switch result {
            case .success(let json):
                guard
                    let json = json as? [String: AnyObject],
                    let resultsJSON = json["results"] as? [[String: AnyObject]]
                    else {
                        DispatchQueue.main.async(execute: {
                            completion(.responseSerializationError(nil))
                        })
                        return
                }
                
                if let reviewJSON = resultsJSON.first {
                    self?.staffReview = StaffReviewResource(json: reviewJSON)
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
}

extension StaffReviewResource {
    
    /**
     Fetches extended info for this staff review. Also re-populates base data in the case where this object is a stub from another parent resource.
     
     - parameter fields: An optional array of fields to return in the response. See the available options at http://www.giantbomb.com/api/documentation#toc-0-36. Pass nil to return everything.
     - parameter completion: A closure containing an optional `RequestError` if the request failed.
     */
    public func fetchExtendedInfo(_ fields: [String]? = nil, completion: @escaping (_ error: RequestError?) -> Void) {
        
        let api = SwiftBomb.framework
        
        guard
            let networkingManager = api.networkingManager,
            let id = id,
            let request = api.requestFactory?.simpleRequest("review/\(id)/", fields: fields) else {
                completion(.frameworkConfigError)
                return
        }
        
        networkingManager.performDetailRequest(request, resource: self, completion: completion)
    }
}
