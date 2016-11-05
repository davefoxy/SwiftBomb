//
//  ObjectResourcePaginator.swift
//  GBAPI
//
//  Created by David Fox on 30/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation
import UIKit
import SwiftBomb

class ObjectResourcePaginator: ResourcePaginator {
    
    var searchTerm: String?
    var pagination: PaginationDefinition
    var sort: SortDefinition
    var isLoading = false
    var hasMore: Bool = true
    var resourceType = ResourceType.object
    var objects = [ObjectResource]()

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
        
        SwiftBomb.fetchObjects(searchTerm, pagination: pagination, sort: sort) { results, error in
            
            self.isLoading = false
            
            if error == nil {
                
                if let objects = results?.resources {
                    
                    self.objects.append(contentsOf: objects)
                    
                    let cellPresenters = self.cellPresentersForResources(objects)
                    
                    
                    self.pagination = PaginationDefinition(self.pagination.offset + objects.count, self.pagination.limit)
                    self.hasMore = (results?.hasMoreResults)!
                    
                    completion(cellPresenters, nil)
                }
            }
            else {
                completion(nil, error)
            }
        }
    }
    
    func cellPresentersForResources(_ objects: [ObjectResource]) -> [ResourceItemCellPresenter] {
        
        var cellPresenters = [ResourceItemCellPresenter]()
        for object in objects {
            
            var subtitle = ""
            if let deck = object.deck {
                subtitle = deck
            }
            
            let cellPresenter = ResourceItemCellPresenter(imageURL: object.image?.small, title: object.name, subtitle: subtitle)
            cellPresenters.append(cellPresenter)
        }
        
        return cellPresenters
    }
    
    func resetPagination() {
        
        self.objects.removeAll()
        self.pagination = PaginationDefinition(0, self.pagination.limit)
        self.hasMore = true
    }
    
    func detailViewControllerForResourceAtIndexPath(indexPath: IndexPath) -> UIViewController {
        
        let viewController = ObjectViewController(style: .grouped)
        viewController.object = objects[(indexPath as NSIndexPath).row]
        
        return viewController
    }
}
