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
        
        let accessoriesRequest = requestFactory?.accessoriesRequest("searchTerm", pagination: PaginationDefinition(offset: 10, limit: 20), sort: SortDefinition(field: "sortField", direction: .ascending), fields: nil)
        
        let requestURL = accessoriesRequest?.urlRequest().url
        
        XCTAssertEqual(requestURL!.host, "www.giantbomb.com")
        XCTAssertEqual(requestURL!.path, "/api/accessories")
        XCTAssert(requestURL!.query!.contains("filter=name:searchTerm"))
        XCTAssert(requestURL!.query!.contains("format=json"))
        XCTAssert(requestURL!.query!.contains("offset=10"))
        XCTAssert(requestURL!.query!.contains("limit=20"))
        XCTAssert(requestURL!.query!.contains("sort=sortField:asc"))
        XCTAssert(requestURL!.query!.contains("api_key=\(authenticationStore.apiKey)"))
    }
    
    func testCharacterRequests() {
        
        let charactersRequest = requestFactory?.charactersRequest("searchTerm", pagination: PaginationDefinition(offset: 10, limit: 20), sort: SortDefinition(field: "sortField", direction: .ascending))
        
        let requestURL = charactersRequest?.urlRequest().url
        
        XCTAssertEqual(requestURL!.path, "/api/characters")
        XCTAssert(requestURL!.query!.contains("filter=name:searchTerm"))
        performBasicURLTests(requestURL!)
    }
    
    func testCompanyRequests() {
        
        let companiesRequest = requestFactory?.companiesRequest("searchTerm", pagination: PaginationDefinition(offset: 10, limit: 20), sort: SortDefinition(field: "sortField", direction: .ascending))
        
        let requestURL = companiesRequest?.urlRequest().url
        
        XCTAssertEqual(requestURL!.path, "/api/companies")
        XCTAssert(requestURL!.query!.contains("filter=name:searchTerm"))
        performBasicURLTests(requestURL!)
    }
    
    func testConceptRequests() {
        
        let conceptsRequest = requestFactory?.conceptsRequest("searchTerm", pagination: PaginationDefinition(offset: 10, limit: 20), sort: SortDefinition(field: "sortField", direction: .ascending))
        
        let requestURL = conceptsRequest?.urlRequest().url
        
        XCTAssertEqual(requestURL!.path, "/api/concepts")
        XCTAssert(requestURL!.query!.contains("filter=name:searchTerm"))
        performBasicURLTests(requestURL!)
        
    }
    
    func testFranchiseRequests() {
        
        let franchisesRequest = requestFactory?.franchisesRequest("searchTerm", pagination: PaginationDefinition(offset: 10, limit: 20), sort: SortDefinition(field: "sortField", direction: .ascending))
        
        let requestURL = franchisesRequest?.urlRequest().url
        
        XCTAssertEqual(requestURL!.path, "/api/franchises")
        XCTAssert(requestURL!.query!.contains("filter=name:searchTerm"))
        performBasicURLTests(requestURL!)
    }
    
    func testGameRequests() {
        
        let gamesRequest = requestFactory?.gamesRequest("searchTerm", pagination: PaginationDefinition(offset: 10, limit: 20), sort: SortDefinition(field: "sortField", direction: .ascending))
        
        let requestURL = gamesRequest?.urlRequest().url
        
        XCTAssertEqual(requestURL!.path, "/api/games")
        XCTAssert(requestURL!.query!.contains("filter=name:searchTerm"))
        performBasicURLTests(requestURL!)
    }
    
    func testGenreRequests() {
        
        let genresRequest = requestFactory?.genreRequest("searchTerm", pagination: PaginationDefinition(offset: 10, limit: 20), sort: SortDefinition(field: "sortField", direction: .ascending))
        
        let requestURL = genresRequest?.urlRequest().url
        
        XCTAssertEqual(requestURL!.path, "/api/genres")
        XCTAssert(requestURL!.query!.contains("filter=name:searchTerm"))
        performBasicURLTests(requestURL!)
    }
    
    func testLocationRequests() {
        
        let locationsRequest = requestFactory?.locationRequest("searchTerm", pagination: PaginationDefinition(offset: 10, limit: 20), sort: SortDefinition(field: "sortField", direction: .ascending))
        
        let requestURL = locationsRequest?.urlRequest().url
        
        XCTAssertEqual(requestURL!.path, "/api/locations")
        XCTAssert(requestURL!.query!.contains("filter=name:searchTerm"))
        performBasicURLTests(requestURL!)
    }
    
    func testObjectRequests() {
        
        let objectsRequest = requestFactory?.objectsRequest("searchTerm", pagination: PaginationDefinition(offset: 10, limit: 20), sort: SortDefinition(field: "sortField", direction: .ascending))
        
        let requestURL = objectsRequest?.urlRequest().url
        
        XCTAssertEqual(requestURL!.path, "/api/objects")
        XCTAssert(requestURL!.query!.contains("filter=name:searchTerm"))
        performBasicURLTests(requestURL!)
    }
    
    func testPersonRequests() {
        
        let peopleRequest = requestFactory?.peopleRequest("searchTerm", pagination: PaginationDefinition(offset: 10, limit: 20), sort: SortDefinition(field: "sortField", direction: .ascending))
        
        let requestURL = peopleRequest?.urlRequest().url
        
        XCTAssertEqual(requestURL!.path, "/api/people")
        XCTAssert(requestURL!.query!.contains("filter=name:searchTerm"))
        performBasicURLTests(requestURL!)
    }
    
    func testVideoRequests() {
        
        let videosRequest = requestFactory?.videosRequest("searchTerm", pagination: PaginationDefinition(offset: 10, limit: 20), sort: SortDefinition(field: "sortField", direction: .ascending))
        
        let requestURL = videosRequest?.urlRequest().url
        
        XCTAssertEqual(requestURL!.path, "/api/videos")
        XCTAssert(requestURL!.query!.contains("filter=name:searchTerm"))
        performBasicURLTests(requestURL!)
    }
    
    func performBasicURLTests(_ url: URL) {
        
        XCTAssertEqual(url.host, "www.giantbomb.com")
        XCTAssert(url.query!.contains("format=json"))
        XCTAssert(url.query!.contains("offset=10"))
        XCTAssert(url.query!.contains("limit=20"))
        XCTAssert(url.query!.contains("sort=sortField:asc"))
        XCTAssert(url.query!.contains("api_key=\(authenticationStore.apiKey)"))
    }
}

class MockAuthenticationStore: AuthenticationStore {
    
    var apiKey = "TEST_API_KEY"
}
