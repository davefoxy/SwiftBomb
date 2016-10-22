//
//  GenreResourcePaginator.swift
//  GBAPI
//
//  Created by David Fox on 30/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation
import UIKit
import SwiftBomb

class GenreResourcePaginator: ResourcePaginator {
    
    var searchTerm: String?
    var pagination: PaginationDefinition
    var sort: SortDefinition
    var isLoading = false
    var hasMore: Bool = true
    var resourceType = ResourceType.genre
    var genres = [GenreResource]()

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
        
        SwiftBomb.fetchGenres(searchTerm, pagination: pagination, sort: sort) { results, error in
            
            self.isLoading = false
            
            if error == nil {
                
                if let genres = results?.resources {
                    
                    self.genres.append(contentsOf: genres)
                    
                    let cellPresenters = self.cellPresentersForResources(genres)
                    
                    self.pagination = PaginationDefinition(self.pagination.offset + genres.count, self.pagination.limit)
                    self.hasMore = (results?.hasMoreResults)!
                    
                    completion(cellPresenters, nil)
                }
            }
            else {
                completion(nil, error)
            }
        }
    }
    
    func cellPresentersForResources(_ genres: [GenreResource]) -> [ResourceItemCellPresenter] {
        
        var cellPresenters = [ResourceItemCellPresenter]()
        for genre in genres {
            
            var subtitle = ""
            if let deck = genre.deck {
                subtitle = deck
            }
            
            let cellPresenter = ResourceItemCellPresenter(imageURL: genre.image?.small, title: genre.name, subtitle: subtitle)
            cellPresenters.append(cellPresenter)
        }
        
        return cellPresenters
    }
    
    func resetPagination() {
        
        self.genres.removeAll()
        self.pagination = PaginationDefinition(0, self.pagination.limit)
        self.hasMore = true
    }
    
    func detailViewControllerForResourceAtIndexPath(indexPath: IndexPath) -> UIViewController {
        
        let viewController = GenreViewController(style: .grouped)
        viewController.genre = genres[(indexPath as NSIndexPath).row]
        
        return viewController
    }
}
