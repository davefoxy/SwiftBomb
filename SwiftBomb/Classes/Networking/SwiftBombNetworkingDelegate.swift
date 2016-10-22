//
//  SwiftBombNetworkingDelegate.swift
//  Pods
//
//  Created by David Fox on 05/06/2016.
//
//

import Foundation

/**
 `SwiftBombNetworkingDelegate` provides a way to listen in on the requests SwiftBomb is making and to allow or deny those requests be made. Send an object conforming to this protocol into your `SwiftBombConfig` instance when initializing the framework.
 */
public protocol SwiftBombNetworkingDelegate {
    
    /// Called when SwiftBomb is about to perform a request to the Giant Bomb API.
    func swiftBombWillPerformRequest(_ request: URLRequest)
    
    /// Allows the denial of requests being sent to the Giant Bomb API.
    func swiftBombShouldPerformRequest(_ request: URLRequest) -> Bool
}
