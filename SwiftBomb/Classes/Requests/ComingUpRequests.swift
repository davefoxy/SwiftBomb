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
     
     - parameter completion: A closure returning an instance of `ComingUpSchedule` where currently-live and scheduled posts, streams and videos on Giant Bomb can be found. Also, an optional `SwiftBombRequestError` may be returned describing any errors which occurred during the request.
     */
    public static func fetchComingUpSchedule(completion: @escaping (_ schedule: ComingUpSchedule?, _ error: SwiftBombRequestError?) -> Void) {
        
        let instance = SwiftBomb.framework
        guard
            let requestFactory = instance.requestFactory,
            let networkingManager = instance.networkingManager else {
                completion(nil, .frameworkConfigError)
                return
        }
        
        var request = requestFactory.simpleRequest("upcoming_json", requiresAuth: false)
        request.baseURLType = .site
        networkingManager.performRequest(request) { result in
            
            switch result {
            case .success(let upcomingJSON):
                
                guard let json = upcomingJSON as? [String: AnyObject] else {
                    completion(nil, .responseSerializationError(nil))
                    return
                }
            
                let schedule = ComingUpSchedule(json: json)
                DispatchQueue.main.async(execute: { 
                    completion(schedule, nil)
                })
            
            case .error(let error):
                
                DispatchQueue.main.async(execute: {
                    completion(nil, error)
                })
            }
        }
    }
}
