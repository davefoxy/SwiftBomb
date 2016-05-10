//
//  SwiftBombProtocols.swift
//  SwiftBomb
//
//  Created by David Fox on 01/05/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

protocol AuthenticationStore {
    
    var apiKey: String { get set }
}

protocol NetworkingManager {
    
    var urlSession: NSURLSession { get set }

    var configuration: SwiftBombConfig { get }
    
    func performPaginatedRequest<T>(request: Request, objectType: T.Type, completion: (PaginatedResults<T>?, error: RequestError?) -> Void)
    
    func performDetailRequest<T: ResourceUpdating>(request: Request, resource: T, completion: (error: RequestError?) -> Void)
    
    func performRequest(request: Request, completion: RequestResult -> Void)
}
