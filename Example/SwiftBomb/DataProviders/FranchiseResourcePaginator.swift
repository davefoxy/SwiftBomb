//
//  FranchiseResourcePaginator.swift
//  GBAPI
//
//  Created by David Fox on 26/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation
import UIKit
import SwiftBomb

class FranchiseResourcePaginator: ResourcePaginator {
    
    var searchTerm: String?
    var pagination: PaginationDefinition
    var sort: SortDefinition
    var isLoading = false
    var hasMore: Bool = true
    var resourceType = ResourceType.Franchise
    var franchises = [GBFranchiseResource]()
    
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
        
        GBAPI.retrieveFranchises(searchTerm, pagination: pagination, sort: sort) { results, error in
            
            self.isLoading = false
            
            if error == nil {
                
                if let franchises = results?.resources {
                    
                    self.franchises.appendContentsOf(franchises)
                    
                    let cellPresenters = self.cellPresentersForResources(franchises)
                    
                    self.pagination = PaginationDefinition(self.pagination.offset + franchises.count, self.pagination.limit)
                    self.hasMore = (results?.hasMoreResults)!
                    
                    completion(cellPresenters: cellPresenters, error: nil)
                }
            }
            else {
                completion(cellPresenters: nil, error: error)
            }
        }
    }
    
    func cellPresentersForResources(games: [GBFranchiseResource]) -> [ResourceItemCellPresenter] {
        
        var cellPresenters = [ResourceItemCellPresenter]()
        for franchise in franchises {
            
            var subtitle = ""
            if let deck = franchise.deck {
                subtitle = deck
            }
            
            let cellPresenter = ResourceItemCellPresenter(imageURL: franchise.image?.small, title: franchise.name, subtitle: subtitle)
            cellPresenters.append(cellPresenter)
        }
        
        return cellPresenters
    }
    
    func resetPagination() {
        
        self.franchises.removeAll()
        self.pagination = PaginationDefinition(0, self.pagination.limit)
        self.hasMore = true
    }
    
    func detailViewControllerForResourceAtIndexPath(indexPath: NSIndexPath) -> UIViewController {
        
        let viewController = FranchiseViewController(style: .Grouped)
        viewController.franchise = franchises[indexPath.row]
        
        return viewController
    }
}