//
//  SearchResultsListViewController.swift
//  GBAPI
//
//  Created by David Fox on 30/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation
import UIKit
import SwiftBomb

class SearchResultsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let cellName = "ResourceTableViewCell"
    var resourcePaginator: ResourcePaginator?
    var searchResults: SearchResults?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    func loadMoreResources(query: String) {
        
        setLoadingPage(true)
        
        SwiftBomb.performSearch(query) { [weak self] searchResults, error in
            
            self?.setLoadingPage(false)
            
            self?.searchResults = searchResults
            self?.tableView.reloadData()
        }
    }
    
    func setLoadingPage(loading: Bool) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = loading
        
        if loading {
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            var indicatorFrame = activityIndicator.frame
            indicatorFrame.size.height += 50
            activityIndicator.frame = indicatorFrame
            activityIndicator.startAnimating()
            
            self.tableView.tableFooterView = activityIndicator
        }
        else {
            self.tableView.tableFooterView = nil
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        guard let searchResults = searchResults else {
            return 0
        }
        
        print("SECTIONS: \(searchResults.availableResourceTypes().count)")
        return searchResults.availableResourceTypes().count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let searchResults = searchResults else {
            return nil
        }
        
        return searchResults.availableResourceTypes()[section].rawValue
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let searchResults = searchResults else {
            return 0
        }
        
        let resourceType = searchResults.availableResourceTypes()[section]
        
        return searchResults.resourceSummariesOfType(resourceType).count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        guard
            let cell = tableView.dequeueReusableCellWithIdentifier(cellName, forIndexPath: indexPath) as? ResourceTableViewCell,
            let searchResults = searchResults
            else {
                assertionFailure("Failed to create tableviewCell with ID '\(cellName)'")
                return UITableViewCell()
        }
        
        let resourceType = searchResults.availableResourceTypes()[indexPath.section]
        let summary = searchResults.resourceSummariesOfType(resourceType)[indexPath.row]

        let cellPresenter = ResourceItemCellPresenter(imageURL: summary.image?.small, title: summary.prettyDescription, subtitle: nil)
        cell.cellPresenter = cellPresenter
        
        return cell
    }
    
    /// MARK: UISearchBarDelegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        guard let searchTerm = searchBar.text else {
            return
        }
        
        searchResults = nil
        tableView.reloadData()
        loadMoreResources(searchTerm)
        searchBar.resignFirstResponder()
    }
}

struct ResourceDescription<T: Resource> {
    
    let title: String
    
}