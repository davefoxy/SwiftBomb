//
//  VideoResourcePaginator.swift
//  GBAPI
//
//  Created by David Fox on 26/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation
import UIKit
import SwiftBomb

class VideoResourcePaginator: ResourcePaginator {
    
    var searchTerm: String?
    var pagination: PaginationDefinition
    var sort: SortDefinition
    var isLoading = false
    var hasMore: Bool = true
    var resourceType = ResourceType.Video
    
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
        
        GBAPI.retrieveVideos(searchTerm, pagination: pagination, sort: sort) { results, error in
            
            self.isLoading = false
            
            if error == nil {
                
                if let videos = results?.resources {
                    
                    var cellPresenters = [ResourceItemCellPresenter]()
                    for video in videos {
                        let cellPresenter = ResourceItemCellPresenter(imageURL: video.image?.small, title: video.name, subtitle: video.deck)
                        cellPresenters.append(cellPresenter)
                    }
                    
                    self.pagination = PaginationDefinition(self.pagination.offset + videos.count, self.pagination.limit)
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
        
        let viewController = CharacterViewController(style: .Grouped)
//        viewController.character = characters[indexPath.row]
        
        return viewController
    }
}