//
//  ComingUpRequests.swift
//  Pods
//
//  Created by David Fox on 23/07/2016.
//
//

import Foundation

extension SwiftBomb {
    
    /**
     Fetches an instance of `ComingUpSchedule` containing a number of `ComingUpScheduleItem` instances. These are essentially the items which appear in the "Coming up on Giant Bomb" panel on the Giant Bomb homepage.
     
     - parameter completion: A closure returning an instance of `ComingUpSchedule` where currently-live and scheduled posts, streams and videos on Giant Bomb can be found. Also, an optional `RequestError` may be returned describing any errors which occurred during the request.
     */
    public static func fetchComingUpSchedule(completion: (ComingUpSchedule?, error: RequestError?) -> Void) {
        
        let instance = SwiftBomb.framework
        guard
            let requestFactory = instance.requestFactory,
            let networkingManager = instance.networkingManager else {
                completion(nil, error: .FrameworkConfigError)
                return
        }
        
        var request = requestFactory.simpleRequest("upcoming_json", requiresAuth: false)
        request.baseURLType = .Site
        networkingManager.performRequest(request) { result in
            
            switch result {
            case .Success(let upcomingJSON):
                
                guard let json = upcomingJSON as? [String: AnyObject] else {
                    completion(nil, error: .ResponseSerializationError(nil))
                    return
                }
            
                let schedule = ComingUpSchedule(json: json)
                dispatch_async(dispatch_get_main_queue(), { 
                    completion(schedule, error: nil)
                })
            
            case .Error(let error):
                
                dispatch_async(dispatch_get_main_queue(), {
                    completion(nil, error: error)
                })
            }
        }
    }
}
