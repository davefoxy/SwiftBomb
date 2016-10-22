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
    
    var urlSession: URLSession { get set }

    var configuration: SwiftBombConfig { get }
    
    func performPaginatedRequest<T>(_ request: SwiftBombRequest, objectType: T.Type, completion: @escaping  (PaginatedResults<T>?, _ error: RequestError?) -> Void)
    
    func performDetailRequest<T: ResourceUpdating>(_ request: SwiftBombRequest, resource: T, completion: @escaping (_ error: RequestError?) -> Void)
    
    func performRequest(_ request: SwiftBombRequest, completion: @escaping (RequestResult) -> Void)
}
