//
//  PlatformViewController.swift
//  SwiftBomb
//
//  Created by David Fox on 08/05/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation
import UIKit
import SwiftBomb

class PlatformViewController: BaseResourceDetailViewController {
    
    var platform: PlatformResource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        platform?.fetchExtendedInfo() { [weak self] error in
            
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
        
        var infos = [ResourceInfoTuple(value: platform?.name, "Name:"), ResourceInfoTuple(value: platform?.deck, "Deck:"), ResourceInfoTuple(value: platform?.install_base, "Install Base:"), ResourceInfoTuple(value: platform?.original_price, "Original Price:")]
        
        if let launchDate = platform?.release_date {
            infos.append(ResourceInfoTuple(value: dateFormatter.string(from: launchDate), "Launch Date:"))
        }
        
        if let dateAdded = platform?.date_added {
            infos.append(ResourceInfoTuple(value: dateFormatter.string(from: dateAdded), "Date Added:"))
        }
        
        if let lastUpdated = platform?.date_last_updated {
            infos.append(ResourceInfoTuple(value: dateFormatter.string(from: lastUpdated), "Last Updated:"))
        }
        
        if (platform?.description != nil) {
            infos.append(ResourceInfoTuple(value: "Tap to view", label: "Description:"))
        }
        
        cell.textLabel?.attributedText = createResourceInfoString(infos)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let description = platform?.description else {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        showWebViewController(description)
    }
}
