//
//  ExtendedInfoTests.swift
//  SwiftBomb
//
//  Created by David Fox on 08/05/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
@testable import SwiftBomb

class ExtendedInfoTests: XCTestCase {

    let configuration = Configuration(apiKey: "")

    override func setUp() {
        
        super.setUp()
        
        SwiftBomb.configure(configuration)
        SwiftBomb.framework.networkingManager?.urlSession = MockURLSession()
    }
    
    override func tearDown() {

        super.tearDown()
        
        SwiftBomb.framework.networkingManager?.urlSession = NSURLSession.sharedSession()
    }

    func testCompanyExtendedInfo() {

        do {
            let mockCompany = CompanyResource(json: ["id": 123])
            
            let jsonData = try NSJSONSerialization.dataWithJSONObject(["results": ["name": "Mock Company", "characters": [["id": 123]]]], options: .PrettyPrinted)
            
            MockURLSession.mockResponse = (jsonData, urlResponse: nil, error: nil)
            
            let asyncExpectation = expectationWithDescription("longRunningFunction")

            mockCompany.fetchExtendedInfo({ error in
                asyncExpectation.fulfill()
            })
            
            waitForExpectationsWithTimeout(5) { error in
                
                XCTAssertEqual(mockCompany.name, "Mock Company")
                XCTAssertEqual(mockCompany.extendedInfo?.characters.count, 1)
                
            }
        }
        catch { XCTFail("Couldn't construct mock JSON") }
    }
}
