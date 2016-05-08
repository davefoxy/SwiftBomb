//
//  ResourcesListViewController.swift
//  GBAPI
//
//  Created by David Fox on 26/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation
import UIKit
import SwiftBomb

struct ResourceItemCellPresenter {
    
    let imageURL: NSURL?
    let title: String?
    let subtitle: String?
}

protocol ResourcePaginator {
    
    var searchTerm: String? { get set }
    var pagination: PaginationDefinition { get set }
    var sort: SortDefinition { get set }
    var isLoading: Bool { get }
    var hasMore: Bool { get }
    
    func loadMore(completion: (cellPresenters: [ResourceItemCellPresenter]?, error: RequestError?) -> Void)
    func resetPagination()
    func detailViewControllerForResourceAtIndexPath(indexPath: NSIndexPath) -> UIViewController
}

class ResourcesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let cellName = "ResourceTableViewCell"
    var resourcePaginator: ResourcePaginator?
    var cellPresenters = [ResourceItemCellPresenter]()
    var shouldLoadFromServer = true
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        loadMoreResources()
    }
    
    func loadMoreResources() {
        
        if shouldLoadFromServer == false { return }
        
        setLoadingPage(true)
        
        resourcePaginator?.loadMore() { [weak self] cellPresenters, error in
            
            self?.setLoadingPage(false)
            
            if let error = error {
                
                var title = ""
                
                switch error {
                case .FrameworkConfigError:
                    title = "Framework Error"
                    
                case .NetworkError(let nsError):
                    title = nsError?.localizedDescription ?? "Unknown Network Error"
                    
                case .ResponseSerializationError(let nsError):
                    title = nsError?.localizedDescription ?? "Unknown Serialisation Error"
                
                case .RequestError(let gbError):
                    title = "Request error: \(gbError)"
                }
                
                let alertController = UIAlertController(title: title, message: nil, preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self?.presentViewController(alertController, animated: true, completion: nil)
            }
            
            if let cellPresenters = cellPresenters {
                self?.cellPresenters.appendContentsOf(cellPresenters)
                self?.tableView.reloadData()
            }
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
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cellPresenters.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCellWithIdentifier(cellName, forIndexPath: indexPath) as? ResourceTableViewCell else {
            assertionFailure("Failed to create tableviewCell with ID '\(cellName)'")
            return UITableViewCell()
        }
        
        let cellPresenter = cellPresenters[indexPath.row]
        cell.cellPresenter = cellPresenter
               
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        guard let detailViewController = resourcePaginator?.detailViewControllerForResourceAtIndexPath(indexPath) else {
            return
        }
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if scrollView.decelerating == false && scrollView.dragging == false {
            return
        }
        
        if resourcePaginator?.isLoading == true {
            return
        }
        
        if resourcePaginator?.hasMore == true && scrollView.contentOffset.y + CGRectGetHeight(scrollView.frame) > scrollView.contentSize.height - (CGRectGetHeight(scrollView.frame) * 1.3) {
            
            loadMoreResources()
        }
    }
    
    /// MARK: UISearchBarDelegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        self.cellPresenters.removeAll()
        self.tableView.reloadData()
        resourcePaginator?.resetPagination()
        resourcePaginator?.searchTerm = searchBar.text
        loadMoreResources()
        searchBar.resignFirstResponder()
    }
}
