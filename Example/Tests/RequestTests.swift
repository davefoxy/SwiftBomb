import UIKit
import XCTest
@testable import SwiftBomb

class RequestTests: XCTestCase {
    
    var configuration = SwiftBombConfig(apiKey: "")
    var requestFactory: RequestFactory?
    let authenticationStore = MockAuthenticationStore()
    
    override func setUp() {
        
        super.setUp()
        
        requestFactory = RequestFactory(configuration: configuration, authenticationStore: authenticationStore)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAccessoryRequests() {
        
        let accessoriesRequest = requestFactory?.accessoriesRequest("searchTerm", pagination: PaginationDefinition(offset: 10, limit: 20), sort: SortDefinition(field: "sortField", direction: .Ascending))
        
        let requestURL = accessoriesRequest?.urlRequest().URL
        
        XCTAssertEqual(requestURL!.host, "www.giantbomb.com")
        XCTAssertEqual(requestURL!.path, "/api/accessories")
        XCTAssert(requestURL!.query!.containsString("filter=name:searchTerm"))
        XCTAssert(requestURL!.query!.containsString("format=json"))
        XCTAssert(requestURL!.query!.containsString("offset=10"))
        XCTAssert(requestURL!.query!.containsString("limit=20"))
        XCTAssert(requestURL!.query!.containsString("sort=sortField:asc"))
        XCTAssert(requestURL!.query!.containsString("api_key=\(authenticationStore.apiKey)"))
    }
    
    func testCharacterRequests() {
        
        let charactersRequest = requestFactory?.charactersRequest("searchTerm", pagination: PaginationDefinition(offset: 10, limit: 20), sort: SortDefinition(field: "sortField", direction: .Ascending))
        
        let requestURL = charactersRequest?.urlRequest().URL
        
        XCTAssertEqual(requestURL!.path, "/api/characters")
        XCTAssert(requestURL!.query!.containsString("filter=name:searchTerm"))
        performBasicURLTests(requestURL!)
    }
    
    func testCompanyRequests() {
        
        let companiesRequest = requestFactory?.companiesRequest("searchTerm", pagination: PaginationDefinition(offset: 10, limit: 20), sort: SortDefinition(field: "sortField", direction: .Ascending))
        
        let requestURL = companiesRequest?.urlRequest().URL
        
        XCTAssertEqual(requestURL!.path, "/api/companies")
        XCTAssert(requestURL!.query!.containsString("filter=name:searchTerm"))
        performBasicURLTests(requestURL!)
    }
    
    func testConceptRequests() {
        
        let conceptsRequest = requestFactory?.conceptsRequest("searchTerm", pagination: PaginationDefinition(offset: 10, limit: 20), sort: SortDefinition(field: "sortField", direction: .Ascending))
        
        let requestURL = conceptsRequest?.urlRequest().URL
        
        XCTAssertEqual(requestURL!.path, "/api/concepts")
        XCTAssert(requestURL!.query!.containsString("filter=name:searchTerm"))
        performBasicURLTests(requestURL!)
        
    }
    
    func testFranchiseRequests() {
        
        let franchisesRequest = requestFactory?.franchisesRequest("searchTerm", pagination: PaginationDefinition(offset: 10, limit: 20), sort: SortDefinition(field: "sortField", direction: .Ascending))
        
        let requestURL = franchisesRequest?.urlRequest().URL
        
        XCTAssertEqual(requestURL!.path, "/api/franchises")
        XCTAssert(requestURL!.query!.containsString("filter=name:searchTerm"))
        performBasicURLTests(requestURL!)
    }
    
    func testGameRequests() {
        
        let gamesRequest = requestFactory?.gamesRequest("searchTerm", pagination: PaginationDefinition(offset: 10, limit: 20), sort: SortDefinition(field: "sortField", direction: .Ascending))
        
        let requestURL = gamesRequest?.urlRequest().URL
        
        XCTAssertEqual(requestURL!.path, "/api/games")
        XCTAssert(requestURL!.query!.containsString("filter=name:searchTerm"))
        performBasicURLTests(requestURL!)
    }
    
    func testGenreRequests() {
        
        let genresRequest = requestFactory?.genreRequest("searchTerm", pagination: PaginationDefinition(offset: 10, limit: 20), sort: SortDefinition(field: "sortField", direction: .Ascending))
        
        let requestURL = genresRequest?.urlRequest().URL
        
        XCTAssertEqual(requestURL!.path, "/api/genres")
        XCTAssert(requestURL!.query!.containsString("filter=name:searchTerm"))
        performBasicURLTests(requestURL!)
    }
    
    func testLocationRequests() {
        
        let locationsRequest = requestFactory?.locationRequest("searchTerm", pagination: PaginationDefinition(offset: 10, limit: 20), sort: SortDefinition(field: "sortField", direction: .Ascending))
        
        let requestURL = locationsRequest?.urlRequest().URL
        
        XCTAssertEqual(requestURL!.path, "/api/locations")
        XCTAssert(requestURL!.query!.containsString("filter=name:searchTerm"))
        performBasicURLTests(requestURL!)
    }
    
    func testObjectRequests() {
        
        let objectsRequest = requestFactory?.objectsRequest("searchTerm", pagination: PaginationDefinition(offset: 10, limit: 20), sort: SortDefinition(field: "sortField", direction: .Ascending))
        
        let requestURL = objectsRequest?.urlRequest().URL
        
        XCTAssertEqual(requestURL!.path, "/api/objects")
        XCTAssert(requestURL!.query!.containsString("filter=name:searchTerm"))
        performBasicURLTests(requestURL!)
    }
    
    func testPersonRequests() {
        
        let peopleRequest = requestFactory?.peopleRequest("searchTerm", pagination: PaginationDefinition(offset: 10, limit: 20), sort: SortDefinition(field: "sortField", direction: .Ascending))
        
        let requestURL = peopleRequest?.urlRequest().URL
        
        XCTAssertEqual(requestURL!.path, "/api/people")
        XCTAssert(requestURL!.query!.containsString("filter=name:searchTerm"))
        performBasicURLTests(requestURL!)
    }
    
    func testStaffReviewRequests() {
        
        let mockGame = GameResource(json: ["id": 999])
        let staffReviewsRequest = requestFactory?.staffReviewRequest(mockGame, pagination: PaginationDefinition(offset: 10, limit: 20), sort: SortDefinition(field: "sortField", direction: .Ascending))
        
        let requestURL = staffReviewsRequest?.urlRequest().URL
        
        XCTAssertEqual(requestURL!.path, "/api/reviews")
        XCTAssert(requestURL!.query!.containsString("filter=game:\(mockGame.id)"))
        performBasicURLTests(requestURL!)
    }
    
    func testVideoRequests() {
        
        let videosRequest = requestFactory?.videosRequest("searchTerm", pagination: PaginationDefinition(offset: 10, limit: 20), sort: SortDefinition(field: "sortField", direction: .Ascending))
        
        let requestURL = videosRequest?.urlRequest().URL
        
        XCTAssertEqual(requestURL!.path, "/api/videos")
        XCTAssert(requestURL!.query!.containsString("filter=name:searchTerm"))
        performBasicURLTests(requestURL!)
    }
    
    func performBasicURLTests(url: NSURL) {
        
        XCTAssertEqual(url.host, "www.giantbomb.com")
        XCTAssert(url.query!.containsString("format=json"))
        XCTAssert(url.query!.containsString("offset=10"))
        XCTAssert(url.query!.containsString("limit=20"))
        XCTAssert(url.query!.containsString("sort=sortField:asc"))
        XCTAssert(url.query!.containsString("api_key=\(authenticationStore.apiKey)"))
    }
}

class MockAuthenticationStore: AuthenticationStore {
    
    var apiKey = "TEST_API_KEY"
}