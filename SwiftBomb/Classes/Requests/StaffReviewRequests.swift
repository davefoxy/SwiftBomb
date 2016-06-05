//
//  StaffReviewRequests.swift
//  SwiftBomb
//
//  Created by David Fox on 01/05/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

extension RequestFactory {
    
    func staffReviewRequest(game: GameResource, fields: [String]? = nil) -> SwiftBombRequest {
        
        var request = SwiftBombRequest(configuration: configuration, path: "reviews", method: .GET, pagination: nil, sort: nil, fields: fields)
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
    public func fetchStaffReview(fields: [String]? = nil, completion: (error: RequestError?) -> Void) -> Void {
        
        let api = SwiftBomb.framework
        
        guard
            let networkingManager = api.networkingManager,
            let request = api.requestFactory?.staffReviewRequest(self, fields: fields) else {
                completion(error: .FrameworkConfigError)
                return
        }
        
        networkingManager.performRequest(request) { [weak self] result in
            
            switch result {
            case .Success(let json):
                guard
                    let json = json as? [String: AnyObject],
                    let resultsJSON = json["results"] as? [[String: AnyObject]]
                    else {
                        dispatch_async(dispatch_get_main_queue(), {
                            completion(error: .ResponseSerializationError(nil))
                        })
                        return
                }
                
                if let reviewJSON = resultsJSON.first {
                    self?.staffReview = StaffReviewResource(json: reviewJSON)
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
}

extension StaffReviewResource {
    
    /**
     Fetches extended info for this staff review. Also re-populates base data in the case where this object is a stub from another parent resource.
     
     - parameter fields: An optional array of fields to return in the response. See the available options at http://www.giantbomb.com/api/documentation#toc-0-36. Pass nil to return everything.
     - parameter completion: A closure containing an optional `RequestError` if the request failed.
     */
    public func fetchExtendedInfo(fields: [String]? = nil, completion: (error: RequestError?) -> Void) {
        
        let api = SwiftBomb.framework
        
        guard
            let networkingManager = api.networkingManager,
            let id = id,
            let request = api.requestFactory?.simpleRequest("review/\(id)/", fields: fields) else {
                completion(error: .FrameworkConfigError)
                return
        }
        
        networkingManager.performDetailRequest(request, resource: self, completion: completion)
    }
}