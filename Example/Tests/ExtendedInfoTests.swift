//
//  ExtendedInfoTests.swift
//  SwiftBomb
//
//  Created by David Fox on 08/05/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import XCTest
@testable import SwiftBomb

class ExtendedInfoTests: XCTestCase {

    let configuration = SwiftBombConfig(apiKey: "")

    override func setUp() {
        
        super.setUp()
        
        SwiftBomb.configure(configuration)
        SwiftBomb.framework.networkingManager?.urlSession = MockURLSession()
    }
    
    override func tearDown() {

        super.tearDown()
        
        SwiftBomb.framework.networkingManager?.urlSession = URLSession.shared
    }
    
    func testAccessoryExtendedInfo() {
        
        do {
            try updateMockedResponse(["results": ["name": "Mock Accessory"] as AnyObject])
            let mockAccessory = AccessoryResource(json: ["id": 123 as AnyObject])
            
            let assertions = {_ in
                XCTAssertEqual(mockAccessory.id, 123)
                XCTAssertEqual(mockAccessory.name, "Mock Accessory")
                } as XCWaitCompletionHandler
            
            performAsyncTest(mockAccessory, assertions: assertions)
        }
        catch { XCTFail("Couldn't construct mock JSON") }
    }
    
    func testCharacterExtendedInfo() {
        
        do {
            try updateMockedResponse((["results": ["name": "Mock Character", "friends": [["id": 123]]]] as AnyObject) as! [String : AnyObject])
            let mockCharacter = CharacterResource(json: ["id": 123 as AnyObject])
            
            let assertions = {_ in
                XCTAssertEqual(mockCharacter.id, 123)
                XCTAssertEqual(mockCharacter.name, "Mock Character")
                XCTAssertEqual(mockCharacter.extendedInfo?.friends?.count, 1)
                } as XCWaitCompletionHandler
            
            performAsyncTest(mockCharacter, assertions: assertions)
        }
        catch { XCTFail("Couldn't construct mock JSON") }
    }

    func testCompanyExtendedInfo() {
        
        do {
            try updateMockedResponse((["results": ["name": "Mock Company", "characters": [["id": 123]]]] as AnyObject) as! [String : AnyObject])
            let mockCompany = CompanyResource(json: ["id": 123 as AnyObject])
            
            let assertions = {_ in
                XCTAssertEqual(mockCompany.id, 123)
                XCTAssertEqual(mockCompany.name, "Mock Company")
                XCTAssertEqual(mockCompany.extendedInfo?.characters?.count, 1)
                } as XCWaitCompletionHandler
            
            performAsyncTest(mockCompany, assertions: assertions)
        }
        catch { XCTFail("Couldn't construct mock JSON") }
    }
    
    func testConceptExtendedInfo() {
        
        do {
            try updateMockedResponse((["results": ["name": "Mock Concept", "characters": [["id": 123]]]] as AnyObject) as! [String : AnyObject])
            let mockConcept = ConceptResource(json: ["id": 123 as AnyObject])
            
            let assertions = {_ in
                XCTAssertEqual(mockConcept.id, 123)
                XCTAssertEqual(mockConcept.name, "Mock Concept")
                XCTAssertEqual(mockConcept.extendedInfo?.characters?.count, 1)
                } as XCWaitCompletionHandler
            
            performAsyncTest(mockConcept, assertions: assertions)
        }
        catch { XCTFail("Couldn't construct mock JSON") }
    }
    
    func testFranchiseExtendedInfo() {
        
        do {
            try updateMockedResponse((["results": ["name": "Mock Franchise", "characters": [["id": 123]]]] as AnyObject) as! [String : AnyObject])
            let mockFranchise = FranchiseResource(json: ["id": 123 as AnyObject])
            
            let assertions = {_ in
                XCTAssertEqual(mockFranchise.id, 123)
                XCTAssertEqual(mockFranchise.name, "Mock Franchise")
                XCTAssertEqual(mockFranchise.extendedInfo?.characters?.count, 1)
                } as XCWaitCompletionHandler
            
            performAsyncTest(mockFranchise, assertions: assertions)
        }
        catch { XCTFail("Couldn't construct mock JSON") }
    }
    
    func testGameExtendedInfo() {
        
        do {
            try updateMockedResponse((["results": ["name": "Mock Game", "characters": [["id": 123]]]] as AnyObject) as! [String : AnyObject])
            let mockGame = GameResource(json: ["id": 123 as AnyObject])
            
            let assertions = {_ in
                XCTAssertEqual(mockGame.id, 123)
                XCTAssertEqual(mockGame.name, "Mock Game")
                XCTAssertEqual(mockGame.extendedInfo?.characters?.count, 1)
                } as XCWaitCompletionHandler
            
            performAsyncTest(mockGame, assertions: assertions)
        }
        catch { XCTFail("Couldn't construct mock JSON") }
    }
    
    func testGameReleaseExtendedInfo() {
        
        do {
            try updateMockedResponse((["results": ["name": "Mock Release", "developers": [["id": 123]]]] as AnyObject) as! [String : AnyObject])
            let mockRelease = GameReleaseResource(json: ["id": 123 as AnyObject])
            
            let assertions = {_ in
                XCTAssertEqual(mockRelease.id, 123)
                XCTAssertEqual(mockRelease.name, "Mock Release")
                XCTAssertEqual(mockRelease.extendedInfo?.developers?.count, 1)
                } as XCWaitCompletionHandler
            
            performAsyncTest(mockRelease, assertions: assertions)
        }
        catch { XCTFail("Couldn't construct mock JSON") }
    }
    
    func testGenreExtendedInfo() {
        
        do {
            try updateMockedResponse((["results": ["name": "Mock Genre"]] as AnyObject) as! [String : AnyObject])
            let mockGenre = GenreResource(json: ["id": 123 as AnyObject])
            
            let assertions = {_ in
                XCTAssertEqual(mockGenre.id, 123)
                XCTAssertEqual(mockGenre.name, "Mock Genre")
                } as XCWaitCompletionHandler
            
            performAsyncTest(mockGenre, assertions: assertions)
        }
        catch { XCTFail("Couldn't construct mock JSON") }
    }
    
    func testLocationExtendedInfo() {
        
        do {
            try updateMockedResponse((["results": ["name": "Mock Location"]] as AnyObject) as! [String : AnyObject])
            let mockLocation = LocationResource(json: ["id": 123 as AnyObject])
            
            let assertions = {_ in
                XCTAssertEqual(mockLocation.id, 123)
                XCTAssertEqual(mockLocation.name, "Mock Location")
                } as XCWaitCompletionHandler
            
            performAsyncTest(mockLocation, assertions: assertions)
        }
        catch { XCTFail("Couldn't construct mock JSON") }
    }
    
    func testObjectExtendedInfo() {
        
        do {
            try updateMockedResponse((["results": ["name": "Mock Object", "games": [["id": 123]]]] as AnyObject) as! [String : AnyObject])
            let mockObject = ObjectResource(json: ["id": 123 as AnyObject])
            
            let assertions = {_ in
                XCTAssertEqual(mockObject.id, 123)
                XCTAssertEqual(mockObject.name, "Mock Object")
                XCTAssertEqual(mockObject.extendedInfo?.games?.count, 1)
                } as XCWaitCompletionHandler
            
            performAsyncTest(mockObject, assertions: assertions)
        }
        catch { XCTFail("Couldn't construct mock JSON") }
    }
    
    func testPersonExtendedInfo() {
        
        do {
            try updateMockedResponse((["results": ["name": "Mock Person", "games": [["id": 123]]]] as AnyObject) as! [String : AnyObject])
            let mockPerson = PersonResource(json: ["id": 123 as AnyObject])
            
            let assertions = {_ in
                XCTAssertEqual(mockPerson.id, 123)
                XCTAssertEqual(mockPerson.name, "Mock Person")
                XCTAssertEqual(mockPerson.extendedInfo?.games?.count, 1)
                } as XCWaitCompletionHandler
            
            performAsyncTest(mockPerson, assertions: assertions)
        }
        catch { XCTFail("Couldn't construct mock JSON") }
    }
    
    func testStaffReviewExtendedInfo() {
        
        do {
            try updateMockedResponse((["results": ["name": "Mock Release", "game": ["id": 123 as AnyObject, "name": "Mock Game"]]] as AnyObject) as! [String : AnyObject])
            let mockReview = StaffReviewResource(json: [:])
            
            let assertions = {_ in
                XCTAssertEqual(mockReview.game?.name, "Mock Game")
                } as XCWaitCompletionHandler
            
            performAsyncTest(mockReview, assertions: assertions)
        }
        catch { XCTFail("Couldn't construct mock JSON") }
    }
    
    func testVideoExtendedInfo() {
        
        do {
            try updateMockedResponse((["results": ["name": "Mock Video"]] as AnyObject) as! [String : AnyObject])
            let mockVideo = VideoResource(json: ["id": 123 as AnyObject])
            
            let assertions = {_ in
                XCTAssertEqual(mockVideo.id, 123)
                XCTAssertEqual(mockVideo.name, "Mock Video")
                } as XCWaitCompletionHandler
            
            performAsyncTest(mockVideo, assertions: assertions)
        }
        catch { XCTFail("Couldn't construct mock JSON") }
    }
   
    // MARK: Utils
    func performAsyncTest<T: ResourceUpdating>(_ resource: T, assertions: @escaping XCWaitCompletionHandler) {
        
        let asyncExpectation = expectation(description: "extendedInfoFetchExpectation")
        
        resource.fetchExtendedInfo(nil) { error in
            asyncExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: assertions)
    }
    
    func updateMockedResponse(_ json: [String: AnyObject]) throws {
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            MockURLSession.mockResponse = (jsonData, urlResponse: nil, error: nil)
        } catch (let error) {
            throw error
        }
    }
}
