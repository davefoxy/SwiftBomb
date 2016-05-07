//
//  GBAPIAuthenticationStore.swift
//  GBAPI
//
//  Created by David Fox on 10/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

class GBAPIKeychainStore: GBAPIAuthenticationStore {
    
    var apiKey: String = "" {
        didSet {
            NSUserDefaults.standardUserDefaults().setObject(apiKey, forKey: "apiKey")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    init() {
        
        if let apiKey = NSUserDefaults.standardUserDefaults().objectForKey("apiKey") as? String {
            self.apiKey = apiKey
        }
    }
}