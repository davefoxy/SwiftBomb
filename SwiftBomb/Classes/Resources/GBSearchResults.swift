//
//  SearchResults.swift
//  GBAPI
//
//  Created by David Fox on 17/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

public struct GBSearchResults {
    
    /// The number of results on this page
    public let number_of_page_results: Int?
    
    /// The number of total results matching the filter conditions specified
    public let number_of_total_results: Int?
    
    /// The value of the offset filter specified, or 0 if not specified
    public let offset: Int?
    
    /// The API version
    public let version: String?
    
    /// An array of `Character`s found in the search results
    public private(set) var characters = [GBCharacterResource]()
    
    /// An array of `Company`s found in the search results
    public private(set) var companies = [GBCompanyResource]()
    
    /// An array of `Concept`s found in the search results
    public private(set) var concepts = [GBConceptResource]()
    
    /// An array of `Franchise`s found in the search results
    public private(set) var franchises = [GBFranchiseResource]()
    
    /// An array of `Game`s found in the search results
    public private(set) var games = [GBGameResource]()
    
    /// An array of `Location`s found in the search results
    public private(set) var locations = [GBLocationResource]()
    
    /// An array of `Object`s found in the search results
    public private(set) var objects = [GBObjectResource]()
    
    /// An array of `Person`s found in the search results
    public private(set) var people = [GBPersonResource]()
    
    /// An array of `Video`s found in the search results
    public private(set) var videos = [GBVideoResource]()
    
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
                        let character = GBCharacterResource(json: resultJSON)
                        characters.append(character)
                        
                    case ResourceType.Company.rawValue:
                        let company = GBCompanyResource(json: resultJSON)
                        companies.append(company)
                        
                    case ResourceType.Concept.rawValue:
                        let concept = GBConceptResource(json: resultJSON)
                        concepts.append(concept)
                        
                    case ResourceType.Franchise.rawValue:
                        let franchise = GBFranchiseResource(json: resultJSON)
                        franchises.append(franchise)
                        
                    case ResourceType.Game.rawValue:
                        let game = GBGameResource(json: resultJSON)
                        games.append(game)
                        
                    case ResourceType.Location.rawValue:
                        let location = GBLocationResource(json: resultJSON)
                        locations.append(location)
                        
                    case ResourceType.Object.rawValue:
                        let object = GBObjectResource(json: resultJSON)
                        objects.append(object)
                    
                    case ResourceType.Person.rawValue:
                        let person = GBPersonResource(json: resultJSON)
                        people.append(person)
                        
                    case ResourceType.Video.rawValue:
                        let video = GBVideoResource(json: resultJSON)
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
     Returns `GBResourceSummary`s representing each of the resources found during the search
     */
    public func resourceSummariesOfType(resourceType: ResourceType) -> [GBResourceSummary] {

        var results = [GBResourceSummary]()
        
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