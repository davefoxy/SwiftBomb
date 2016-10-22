//
//  AccessoryResourcePaginator.swift
//  GBAPI
//
//  Created by David Fox on 30/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation
import UIKit
import SwiftBomb

class AccessoryResourcePaginator: ResourcePaginator {
    
    var searchTerm: String?
    var pagination: PaginationDefinition
    var sort: SortDefinition
    var isLoading = false
    var hasMore: Bool = true
    var accessories = [AccessoryResource]()

    init(searchTerm: String? = nil, pagination: PaginationDefinition = PaginationDefinition(offset: 0, limit: 30), sort: SortDefinition = SortDefinition(field: "name", direction: .ascending)) {
        
        self.searchTerm = searchTerm
        self.pagination = pagination
        self.sort = sort
    }
    
    func loadMore(completion: @escaping (_ cellPresenters: [ResourceItemCellPresenter]?, _ error: RequestError?) -> Void) {
        
        if isLoading {
            
            return
        }
        
        isLoading = true
        
        SwiftBomb.fetchAccessories(searchTerm, pagination: pagination, sort: sort) { results, error in
            
            self.isLoading = false
            
            if error == nil {
                
                if let accessories = results?.resources {
                    
                    self.accessories.append(contentsOf: accessories)
                    
                    var cellPresenters = [ResourceItemCellPresenter]()
                    for accessory in accessories {
                        
                        var subtitle = ""
                        if let deck = accessory.deck {
                            subtitle = deck
                        }
                        
                        let cellPresenter = ResourceItemCellPresenter(imageURL: accessory.image?.small, title: accessory.name, subtitle: subtitle)
                        cellPresenters.append(cellPresenter)
                    }
                    
                    self.pagination = PaginationDefinition(self.pagination.offset + accessories.count, self.pagination.limit)
                    self.hasMore = (results?.hasMoreResults)!
                    
                    completion(cellPresenters, nil)
                }
            }
            else {
                completion(nil, error)
            }
        }
    }
    
    func resetPagination() {
        
        self.accessories.removeAll()
        self.pagination = PaginationDefinition(0, self.pagination.limit)
        self.hasMore = true
    }
    
    func detailViewControllerForResourceAtIndexPath(indexPath: IndexPath) -> UIViewController {
        
        let viewController = AccessoryViewController(style: .grouped)
        viewController.accessory = accessories[(indexPath as NSIndexPath).row]
        
        return viewController
    }
}
