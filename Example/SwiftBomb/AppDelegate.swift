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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let networkingDelegate = NetworkingDelegate()
        
        let configuration = SwiftBombConfig(apiKey: "YOUR_API_KEY", loggingLevel: .requests, userAgentIdentifier: "SwiftBomb Sample App", networkingDelegate: networkingDelegate, urlRequestCachePolicy: .useProtocolCachePolicy)
        SwiftBomb.configure(configuration)
        
        return true
    }
}

class NetworkingDelegate: SwiftBombNetworkingDelegate {
    
    func swiftBombWillPerformRequest(_ request: URLRequest) {
        
        print("SwiftBomb will perform request: \(request)")
    }
    
    func swiftBombShouldPerformRequest(_ request: URLRequest) -> Bool {
        
        return true
    }
    
    func swiftBombDidCompleteRequest(_ request: URLRequest, result: SwiftBombRequestResult) {
        
        print("SwiftBomb did complete request: \(result)")
    }
}
