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
    
    let imageURL: URL?
    let title: String?
    let subtitle: String?
}

protocol ResourcePaginator {
    
    var searchTerm: String? { get set }
    var pagination: PaginationDefinition { get set }
    var sort: SortDefinition { get set }
    var isLoading: Bool { get }
    var hasMore: Bool { get }
    
    func loadMore(completion: @escaping (_ cellPresenters: [ResourceItemCellPresenter]?, _ error: SwiftBombRequestError?) -> Void)
    func resetPagination()
    func detailViewControllerForResourceAtIndexPath(indexPath: IndexPath) -> UIViewController
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
                case .frameworkConfigError:
                    title = "Framework Error"
                    
                case .networkError(let nsError):
                    title = nsError?.localizedDescription ?? "Unknown Network Error"
                    
                case .responseSerializationError(let nsError):
                    title = nsError?.localizedDescription ?? "Unknown Serialisation Error"
                
                case .requestError(let gbError):
                    title = "Request error: \(gbError)"
                }
                
                let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alertController, animated: true, completion: nil)
            }
            
            if let cellPresenters = cellPresenters {
                self?.cellPresenters.append(contentsOf: cellPresenters)
                self?.tableView.reloadData()
            }
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
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cellPresenters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath) as? ResourceTableViewCell else {
            assertionFailure("Failed to create tableviewCell with ID '\(cellName)'")
            return UITableViewCell()
        }
        
        let cellPresenter = cellPresenters[(indexPath as NSIndexPath).row]
        cell.cellPresenter = cellPresenter
               
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let detailViewController = resourcePaginator?.detailViewControllerForResourceAtIndexPath(indexPath: indexPath) else {
            return
        }
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.isDecelerating == false && scrollView.isDragging == false {
            return
        }
        
        if resourcePaginator?.isLoading == true {
            return
        }
        
        if resourcePaginator?.hasMore == true && scrollView.contentOffset.y + scrollView.frame.height > scrollView.contentSize.height - (scrollView.frame.height * 1.3) {
            
            loadMoreResources()
        }
    }
    
    /// MARK: UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.cellPresenters.removeAll()
        self.tableView.reloadData()
        resourcePaginator?.resetPagination()
        resourcePaginator?.searchTerm = searchBar.text
        loadMoreResources()
        searchBar.resignFirstResponder()
    }
}
