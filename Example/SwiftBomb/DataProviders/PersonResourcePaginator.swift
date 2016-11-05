//
//  PersonResourcePaginator.swift
//  GBAPI
//
//  Created by David Fox on 30/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation
import UIKit
import SwiftBomb

class PersonResourcePaginator: ResourcePaginator {
    
    var searchTerm: String?
    var pagination: PaginationDefinition
    var sort: SortDefinition
    var isLoading = false
    var hasMore: Bool = true
    var resourceType = ResourceType.person
    var people = [PersonResource]()

    init(searchTerm: String? = nil, pagination: PaginationDefinition = PaginationDefinition(offset: 0, limit: 30), sort: SortDefinition = SortDefinition(field: "name", direction: .ascending)) {
        
        self.searchTerm = searchTerm
        self.pagination = pagination
        self.sort = sort
    }
    
    func loadMore(completion: @escaping (_ cellPresenters: [ResourceItemCellPresenter]?, _ error: SwiftBombRequestError?) -> Void) {
        
        if isLoading {
            
            return
        }
        
        isLoading = true
        
        SwiftBomb.fetchPeople(searchTerm, pagination: pagination, sort: sort) { results, error in
            
            self.isLoading = false
            
            if error == nil {
                
                if let people = results?.resources {
                    
                    self.people.append(contentsOf: people)
                    
                    let cellPresenters = self.cellPresentersForResources(people)
                    
                    self.pagination = PaginationDefinition(self.pagination.offset + people.count, self.pagination.limit)
                    self.hasMore = (results?.hasMoreResults)!
                    
                    completion(cellPresenters, nil)
                }
            }
            else {
                completion(nil, error)
            }
        }
    }
    
    func cellPresentersForResources(_ people: [PersonResource]) -> [ResourceItemCellPresenter] {
        
        var cellPresenters = [ResourceItemCellPresenter]()
        for person in people {
            
            var subtitle = ""
            if let deck = person.deck {
                subtitle = deck
            }
            
            let cellPresenter = ResourceItemCellPresenter(imageURL: person.image?.small, title: person.name, subtitle: subtitle)
            cellPresenters.append(cellPresenter)
        }
        
        return cellPresenters
    }
    
    func resetPagination() {
        
        self.people.removeAll()
        self.pagination = PaginationDefinition(0, self.pagination.limit)
        self.hasMore = true
    }
    
    func detailViewControllerForResourceAtIndexPath(indexPath: IndexPath) -> UIViewController {
        
        let viewController = PersonViewController(style: .grouped)
        viewController.person = people[(indexPath as NSIndexPath).row]
        
        return viewController
    }
}
