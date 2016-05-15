//
//  PaginationTests.swift
//  SwiftBomb
//
//  Created by David Fox on 08/05/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import XCTest
@testable import SwiftBomb

class PaginationTests: XCTestCase {

    let configuration = SwiftBombConfig(apiKey: "")

    override func setUp() {
        
        super.setUp()

        SwiftBomb.configure(configuration)
        SwiftBomb.framework.networkingManager?.urlSession = MockURLSession()
    }
    
    override func tearDown() {

        super.tearDown()
        
        SwiftBomb.framework.networkingManager?.urlSession = NSURLSession.sharedSession()
    }

    func testPaginationCounts() {
        
        let mockDataURL = NSBundle(forClass: PaginationTests.self).URLForResource("FivePaginatedResultsJSON", withExtension: "json")
        
        let mockDataString = NSData(contentsOfURL: mockDataURL!)
        MockURLSession.mockResponse = (mockDataString, urlResponse: nil, error: nil)

        let emptyRequest = SwiftBombRequest(configuration: configuration, path: "", method: .GET)
        
        let asyncExpectation = expectationWithDescription("extendedInfoFetchExpectation")
        
        var resourcesCount = 0
        var numberOfPageResults = 0
        var numberOfTotalResults = 0
        
        SwiftBomb.framework.networkingManager?.performPaginatedRequest(emptyRequest, objectType: CharacterResource.self, completion: { results, error in
            
            resourcesCount = (results?.resources.count)!
            numberOfPageResults = (results?.number_of_page_results)!
            numberOfTotalResults = (results?.number_of_total_results)!
            asyncExpectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(5) { error in
            
            XCTAssertEqual(resourcesCount, 5)
            XCTAssertEqual(numberOfPageResults, 5)
            XCTAssertEqual(numberOfTotalResults, 100)
        }
    }

}
