//
//  MockNetworkingManager.swift
//  SwiftBomb
//
//  Created by David Fox on 08/05/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation
@testable import SwiftBomb

class MockURLSession: URLSession {
    
    var completionHandler: ((Data?, URLResponse?, NSError?) -> Void)?
    
    static var mockResponse: (data: Data?, urlResponse: URLResponse?, error: NSError?) = (data: nil, urlResponse: nil, error: nil)
    
    override open class var shared: URLSession {
        return MockURLSession()
    }

    func dataTask(with url: URL, completionHandler: ((Data?, URLResponse?, NSError?) -> Void)?) -> URLSessionDataTask {
        
        self.completionHandler = completionHandler
        return MockTask(response: MockURLSession.mockResponse, completionHandler: completionHandler)
    }
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        
        self.completionHandler = completionHandler
        return MockTask(response: MockURLSession.mockResponse, completionHandler: completionHandler)
    }
    
    class MockTask: URLSessionDataTask {
        
        typealias Response = (data: Data?, urlResponse: URLResponse?, error: NSError?)
        var mockResponse: Response
        let completionHandler: ((Data?, URLResponse?, NSError?) -> Void)?
        
        init(response: Response, completionHandler: ((Data?, URLResponse?, NSError?) -> Void)?) {
            
            self.mockResponse = response
            self.completionHandler = completionHandler
        }
        
        override func resume() {
            
            completionHandler!(mockResponse.data, mockResponse.urlResponse, mockResponse.error)
        }
    }
}
