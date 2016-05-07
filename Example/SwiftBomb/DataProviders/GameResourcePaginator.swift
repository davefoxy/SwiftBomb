//
//  GameResourcePaginator.swift
//  GBAPI
//
//  Created by David Fox on 26/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation
import UIKit
import SwiftBomb

class GameResourcePaginator: ResourcePaginator {
    
    var searchTerm: String?
    var pagination: PaginationDefinition
    var sort: SortDefinition
    var isLoading = false
    var hasMore: Bool = true
    var resourceType = ResourceType.Game
    let dateFormatter = NSDateFormatter()
    var games = [GBGameResource]()
    
    init(searchTerm: String? = nil, pagination: PaginationDefinition = PaginationDefinition(offset: 0, limit: 30), sort: SortDefinition = SortDefinition(field: "name", direction: .Ascending)) {
        
        dateFormatter.dateStyle = .MediumStyle
        self.searchTerm = searchTerm
        self.pagination = pagination
        self.sort = sort
    }
    
    func loadMore(completion: (cellPresenters: [ResourceItemCellPresenter]?, error: GBAPIError?) -> Void) {
        
        if isLoading {
            
            return
        }
        
        isLoading = true
        
        GBAPI.retrieveGames(searchTerm, pagination: pagination, sort: sort) { results, error in
            
            self.isLoading = false
            
            if error == nil {
                
                if let games = results?.resources {
                    
                    self.games.appendContentsOf(games)
                    
                    let cellPresenters = self.cellPresentersForResources(games)
                    
                    self.pagination = PaginationDefinition(self.pagination.offset + games.count, self.pagination.limit)
                    self.hasMore = (results?.hasMoreResults)!
                    
                    completion(cellPresenters: cellPresenters, error: nil)
                }
            }
            else {
                completion(cellPresenters: nil, error: error)
            }
        }
    }
    
    func cellPresentersForResources(games: [GBGameResource]) -> [ResourceItemCellPresenter] {
        
        var cellPresenters = [ResourceItemCellPresenter]()
        for game in games {
            
            var subtitle = ""
            if let originalReleaseDate = game.original_release_date {
                subtitle = "Release date: \(dateFormatter.stringFromDate(originalReleaseDate))"
            }
            
            let cellPresenter = ResourceItemCellPresenter(imageURL: game.image?.small, title: game.name, subtitle: subtitle)
            cellPresenters.append(cellPresenter)
        }
        
        return cellPresenters
    }
    
    func resetPagination() {
        
        self.games.removeAll()
        self.pagination = PaginationDefinition(0, self.pagination.limit)
        self.hasMore = true
    }
    
    func detailViewControllerForResourceAtIndexPath(indexPath: NSIndexPath) -> UIViewController {
        
        let viewController = GameViewController(style: .Grouped)
        viewController.game = games[indexPath.row]
        
        return viewController
    }
}