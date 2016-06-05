//
//  AppDelegate.swift
//  SwiftBomb
//
//  Created by David Fox on 05/02/2016.
//  Copyright (c) 2016 David Fox. All rights reserved.
//

import UIKit
import SwiftBomb

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let networkingDelegate = NetworkingDelegate()
        
        let configuration = SwiftBombConfig(apiKey: "YOUR_API_KEY", loggingLevel: .Requests, userAgentIdentifier: "Your User Agent", networkingDelegate: networkingDelegate, urlRequestCachePolicy: .UseProtocolCachePolicy)
        SwiftBomb.configure(configuration)
        
        return true
    }
}

class NetworkingDelegate: SwiftBombNetworkingDelegate {
    
    func swiftBombWillPerformRequest(request: NSURLRequest) {
        
        print("SwiftBomb will perform request: \(request)")
    }
    
    func swiftBombShouldPerformRequest(request: NSURLRequest) -> Bool {
        
        return true
    }
}