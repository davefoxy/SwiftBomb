//
//  SearchResults.swift
//  SwiftBomb
//
//  Created by David Fox on 17/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

/**
 A struct containing the results of a call to the Giant Bomb search API. Clients can do so by calling `performSearch(_:resourceTypes:pagination:sort:completion:)` on the `SwiftBomb` singleton.
 */
public struct SearchResults {
    
    /// The number of results on this page.
    public let number_of_page_results: Int?
    
    /// The number of total results matching the filter conditions specified.
    public let number_of_total_results: Int?
    
    /// The value of the offset filter specified, or 0 if not specified.
    public let offset: Int?
    
    /// The API version.
    public let version: String?
    
    /// An array of `CharacterResource`s found in the search results.
    public private(set) var characters = [CharacterResource]()
    
    /// An array of `CompanyResource`s found in the search results.
    public private(set) var companies = [CompanyResource]()
    
    /// An array of `ConceptResource`s found in the search results.
    public private(set) var concepts = [ConceptResource]()
    
    /// An array of `FranchiseResource`s found in the search results.
    public private(set) var franchises = [FranchiseResource]()
    
    /// An array of `GameResource`s found in the search results.
    public private(set) var games = [GameResource]()
    
    /// An array of `LocationResource`s found in the search results.
    public private(set) var locations = [LocationResource]()
    
    /// An array of `ObjectResource`s found in the search results.
    public private(set) var objects = [ObjectResource]()
    
    /// An array of `PersonResource`s found in the search results.
    public private(set) var people = [PersonResource]()
    
    /// An array of `VideoResource`s found in the search results.
    public private(set) var videos = [VideoResource]()
    
    /// Used to create an instance of `SearchResults` from JSON.
    init(json: [String : AnyObject]) {
        
        number_of_page_results = json["number_of_page_results"] as? Int
        number_of_total_results = json["number_of_total_results"] as? Int
        offset = json["offset"] as? Int
        version = json["version"] as? String
        
        if let resultsJSON = json["results"] as? [[String: AnyObject]] {
            
            for resultJSON in resultsJSON {
                
                if let resourceType = resultJSON["resource_type"] as? String {
                    
                    switch resourceType {
                    case ResourceType.Character.rawValue:
                        let character = CharacterResource(json: resultJSON)
                        characters.append(character)
                        
                    case ResourceType.Company.rawValue:
                        let company = CompanyResource(json: resultJSON)
                        companies.append(company)
                        
                    case ResourceType.Concept.rawValue:
                        let concept = ConceptResource(json: resultJSON)
                        concepts.append(concept)
                        
                    case ResourceType.Franchise.rawValue:
                        let franchise = FranchiseResource(json: resultJSON)
                        franchises.append(franchise)
                        
                    case ResourceType.Game.rawValue:
                        let game = GameResource(json: resultJSON)
                        games.append(game)
                        
                    case ResourceType.Location.rawValue:
                        let location = LocationResource(json: resultJSON)
                        locations.append(location)
                        
                    case ResourceType.Object.rawValue:
                        let object = ObjectResource(json: resultJSON)
                        objects.append(object)
                        
                    case ResourceType.Person.rawValue:
                        let person = PersonResource(json: resultJSON)
                        people.append(person)
                        
                    case ResourceType.Video.rawValue:
                        let video = VideoResource(json: resultJSON)
                        videos.append(video)
                        
                    default:
                        // Unsupported resource_type
                        break
                    }
                }
            }
        }
    }
    
    /**
     Returns an array of the types of resource which were found during the search
     */
    public func availableResourceTypes() -> [ResourceType] {
        
        var types = [ResourceType]()
        
        if (characters.count > 0) { types.append(.Character) }
        if (companies.count > 0) { types.append(.Company) }
        if (concepts.count > 0) { types.append(.Concept) }
        if (franchises.count > 0) { types.append(.Franchise) }
        if (games.count > 0) { types.append(.Game) }
        if (locations.count > 0) { types.append(.Location) }
        if (objects.count > 0) { types.append(.Object) }
        if (people.count > 0) { types.append(.Person) }
        if (videos.count > 0) { types.append(.Video) }
        
        return types
    }
    
    /**
     Returns `ResourceSummary`s representing each of the resources found during the search
     */
    public func resourceSummariesOfType(resourceType: ResourceType) -> [ResourceSummary] {
        
        var results = [ResourceSummary]()
        
        switch resourceType {
        case .Character:
            for character in characters {
                if let summary = character.resourceSummary() {
                    results.append(summary)
                }
            }
            
        case .Company:
            for company in companies {
                if let summary = company.resourceSummary() {
                    results.append(summary)
                }
            }
            
        case .Concept:
            for concept in concepts {
                if let summary = concept.resourceSummary() {
                    results.append(summary)
                }
            }
            
        case .Franchise:
            for franchise in franchises {
                if let summary = franchise.resourceSummary() {
                    results.append(summary)
                }
            }
            
        case .Game:
            for game in games {
                if let summary = game.resourceSummary() {
                    results.append(summary)
                }
            }
            
        case .Location:
            for location in locations {
                if let summary = location.resourceSummary() {
                    results.append(summary)
                }
            }
            
        case .Object:
            for object in objects {
                if let summary = object.resourceSummary() {
                    results.append(summary)
                }
            }
            
        case .Person:
            for person in people {
                if let summary = person.resourceSummary() {
                    results.append(summary)
                }
            }
            
        case .Video:
            for video in videos {
                if let summary = video.resourceSummary() {
                    results.append(summary)
                }
            }
            
        default:
            // Not all resource types are returnable by the Giant Bomb search API
            break
            
        }
        
        return results
    }
}