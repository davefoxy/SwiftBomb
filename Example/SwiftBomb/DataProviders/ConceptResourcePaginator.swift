//
//  ConceptResourcePaginator.swift
//  GBAPI
//
//  Created by David Fox on 26/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation
import UIKit
import SwiftBomb

class ConceptResourcePaginator: ResourcePaginator {
    
    var searchTerm: String?
    var pagination: PaginationDefinition
    var sort: SortDefinition
    var isLoading = false
    var hasMore: Bool = true
    var resourceType = ResourceType.concept
    var concepts = [ConceptResource]()
    
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
        
        SwiftBomb.fetchConcepts(searchTerm, pagination: pagination, sort: sort) { results, error in
            
            self.isLoading = false
            
            if error == nil {
                
                if let concepts = results?.resources {
                    
                    self.concepts.append(contentsOf: concepts)
                    
                    let cellPresenters = self.cellPresentersForResources(concepts)
                    
                    self.pagination = PaginationDefinition(self.pagination.offset + concepts.count, self.pagination.limit)
                    self.hasMore = (results?.hasMoreResults)!
                    
                    completion(cellPresenters, nil)
                }
            }
            else {
                completion(nil, error)
            }
        }
    }
    
    func cellPresentersForResources(_ concepts: [ConceptResource]) -> [ResourceItemCellPresenter] {
        
        var cellPresenters = [ResourceItemCellPresenter]()
        for concept in concepts {
            
            var subtitle = ""
            if let deck = concept.deck {
                subtitle = deck
            }
            
            let cellPresenter = ResourceItemCellPresenter(imageURL: concept.image?.small, title: concept.name, subtitle: subtitle)
            cellPresenters.append(cellPresenter)
        }
        
        return cellPresenters
    }
    
    func resetPagination() {
        
        self.concepts.removeAll()
        self.pagination = PaginationDefinition(0, self.pagination.limit)
        self.hasMore = true
    }
    
    func detailViewControllerForResourceAtIndexPath(indexPath: IndexPath) -> UIViewController {
        
        let viewController = ConceptViewController(style: .grouped)
        viewController.concept = concepts[(indexPath as NSIndexPath).row]
        
        return viewController
    }
}
