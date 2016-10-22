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
    
    func loadMoreResources(_ query: String) {
        
        setLoadingPage(true)
        
        SwiftBomb.performSearch(query) { [weak self] searchResults, error in
            
            self?.setLoadingPage(false)
            
            self?.searchResults = searchResults
            self?.tableView.reloadData()
        }
    }
    
    func setLoadingPage(_ loading: Bool) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = loading
        
        if loading {
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        guard let searchResults = searchResults else {
            return 0
        }
        
        return searchResults.availableResourceTypes().count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let searchResults = searchResults else {
            return nil
        }
        
        return searchResults.availableResourceTypes()[section].rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let searchResults = searchResults else {
            return 0
        }
        
        let resourceType = searchResults.availableResourceTypes()[section]
        
        return searchResults.resourceSummariesOfType(resourceType).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as? ResourceTableViewCell,
            let searchResults = searchResults
            else {
                assertionFailure("Failed to create tableviewCell with ID '\(cellName)'")
                return UITableViewCell()
        }
        
        let resourceType = searchResults.availableResourceTypes()[(indexPath as NSIndexPath).section]
        let summary = searchResults.resourceSummariesOfType(resourceType)[(indexPath as NSIndexPath).row]

        let cellPresenter = ResourceItemCellPresenter(imageURL: summary.image?.small, title: summary.prettyDescription, subtitle: nil)
        cell.cellPresenter = cellPresenter
        
        return cell
    }
    
    /// MARK: UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchTerm = searchBar.text else {
            return
        }
        
        searchResults = nil
        tableView.reloadData()
        loadMoreResources(searchTerm)
        searchBar.resignFirstResponder()
    }
}
