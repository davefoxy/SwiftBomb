//
//  GenreViewController.swift
//  SwiftBomb
//
//  Created by David Fox on 07/05/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation
import UIKit
import SwiftBomb

class GenreViewController: BaseResourceDetailViewController {
    
    var genre: GenreResource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        genre?.fetchExtendedInfo() { [weak self] error in
            
            self?.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        
        var infos = [ResourceInfoTuple(value: genre?.name, "Name:"), ResourceInfoTuple(value: genre?.deck, "Deck:")]
        
        if let dateAdded = genre?.date_added {
            infos.append(ResourceInfoTuple(value: dateFormatter.string(from: dateAdded), "Date Added:"))
        }
        
        if let lastUpdated = genre?.date_last_updated {
            infos.append(ResourceInfoTuple(value: dateFormatter.string(from: lastUpdated), "Last Updated:"))
        }
        
        if (genre?.description != nil) {
            infos.append(ResourceInfoTuple(value: "Tap to view", label: "Description:"))
        }
        
        cell.textLabel?.attributedText = createResourceInfoString(infos)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let description = genre?.description else {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        showWebViewController(description)
    }
}
