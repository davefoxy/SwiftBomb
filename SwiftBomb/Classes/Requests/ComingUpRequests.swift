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
     Fetches a list of `ComingUpItemResource` instances. These are essentially the items which appear in the "Coming up on Giant Bomb" panel on the Giant Bomb homepage.
     
     - parameter completion: A closure returning an array of `ComingUpItemResource` objects and an optional `RequestError` explaining any errors which occurred during the request.
     */
    public static func fetchComingUpItems(completion: ([ComingUpItemResource], error: RequestError?) -> Void) {
        
        let instance = SwiftBomb.framework
        guard
            let requestFactory = instance.requestFactory,
            let networkingManager = instance.networkingManager else {
                completion([], error: .FrameworkConfigError)
                return
        }
        
        var request = requestFactory.simpleRequest("upcoming_json", requiresAuth: false)
        request.baseURLType = .Site
        networkingManager.performRequest(request) { result in
            
            switch result {
            case .Success(let upcomingJSON):
                
                guard
                    let json = upcomingJSON as? [String: AnyObject],
                    let comingUpItemDicts = json["upcoming"] as? [[String: AnyObject]] else {
                        completion([], error: .ResponseSerializationError(nil))
                        return
                }
            
                var comingUpItems = [ComingUpItemResource]()
                for comingUpItemDict in comingUpItemDicts {
                    
                    let comingUpItem = ComingUpItemResource(json: comingUpItemDict)
                    comingUpItems.append(comingUpItem)
                }
                
                dispatch_async(dispatch_get_main_queue(), { 
                    completion(comingUpItems, error: nil)
                })
            
            case .Error(let error):
                
                dispatch_async(dispatch_get_main_queue(), {
                    completion([], error: error)
                })
            }
        }
    }
}
