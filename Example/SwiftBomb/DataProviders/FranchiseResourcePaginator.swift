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
    var resourceType = ResourceType.franchise
    var franchises = [FranchiseResource]()
    
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
        
        SwiftBomb.fetchFranchises(searchTerm, pagination: pagination, sort: sort) { results, error in
            
            self.isLoading = false
            
            if error == nil {
                
                if let franchises = results?.resources {
                    
                    self.franchises.append(contentsOf: franchises)
                    
                    let cellPresenters = self.cellPresentersForResources(franchises)
                    
                    self.pagination = PaginationDefinition(self.pagination.offset + franchises.count, self.pagination.limit)
                    self.hasMore = (results?.hasMoreResults)!
                    
                    completion(cellPresenters, nil)
                }
            }
            else {
                completion(nil, error)
            }
        }
    }
    
    func cellPresentersForResources(_ games: [FranchiseResource]) -> [ResourceItemCellPresenter] {
        
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
    
    func detailViewControllerForResourceAtIndexPath(indexPath: IndexPath) -> UIViewController {
        
        let viewController = FranchiseViewController(style: .grouped)
        viewController.franchise = franchises[(indexPath as NSIndexPath).row]
        
        return viewController
    }
}
