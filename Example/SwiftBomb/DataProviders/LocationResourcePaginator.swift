//
//  LocationResourcePaginator.swift
//  GBAPI
//
//  Created by David Fox on 30/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation
import UIKit
import SwiftBomb

class LocationResourcePaginator: ResourcePaginator {
    
    var searchTerm: String?
    var pagination: PaginationDefinition
    var sort: SortDefinition
    var isLoading = false
    var hasMore: Bool = true
    var resourceType = ResourceType.Location
    
    init(searchTerm: String? = nil, pagination: PaginationDefinition = PaginationDefinition(offset: 0, limit: 30), sort: SortDefinition = SortDefinition(field: "name", direction: .Ascending)) {
        
        self.searchTerm = searchTerm
        self.pagination = pagination
        self.sort = sort
    }
    
    func loadMore(completion: (cellPresenters: [ResourceItemCellPresenter]?, error: GBAPIError?) -> Void) {
        
        if isLoading {
            
            return
        }
        
        isLoading = true
        
        GBAPI.retrieveLocations(searchTerm, pagination: pagination, sort: sort) { results, error in
            
            self.isLoading = false
            
            if error == nil {
                
                if let locations = results?.resources {
                    
                    var cellPresenters = [ResourceItemCellPresenter]()
                    for location in locations {
                        
                        var subtitle = ""
                        if let deck = location.deck {
                            subtitle = deck
                        }
                        
                        let cellPresenter = ResourceItemCellPresenter(imageURL: location.image?.small, title: location.name, subtitle: subtitle)
                        cellPresenters.append(cellPresenter)
                    }
                    
                    self.pagination = PaginationDefinition(self.pagination.offset + locations.count, self.pagination.limit)
                    self.hasMore = (results?.hasMoreResults)!
                    
                    completion(cellPresenters: cellPresenters, error: nil)
                }
            }
            else {
                completion(cellPresenters: nil, error: error)
            }
        }
    }
    
    func resetPagination() {
        
        self.pagination = PaginationDefinition(0, self.pagination.limit)
        self.hasMore = true
    }
    
    func detailViewControllerForResourceAtIndexPath(indexPath: NSIndexPath) -> UIViewController {
        
        let viewController = CharacterViewController()
//        viewController.character = characters[indexPath.row]
        
        return viewController
    }
}