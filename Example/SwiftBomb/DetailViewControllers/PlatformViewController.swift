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
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .ByWordWrapping
        
        var infos = [ResourceInfoTuple(value: platform?.name, "Name:"), ResourceInfoTuple(value: platform?.deck, "Deck:"), ResourceInfoTuple(value: platform?.install_base, "Install Base:"), ResourceInfoTuple(value: platform?.original_price, "Original Price:")]
        
        if let launchDate = platform?.release_date {
            infos.append(ResourceInfoTuple(value: dateFormatter.stringFromDate(launchDate), "Launch Date:"))
        }
        
        if let dateAdded = platform?.date_added {
            infos.append(ResourceInfoTuple(value: dateFormatter.stringFromDate(dateAdded), "Date Added:"))
        }
        
        if let lastUpdated = platform?.date_last_updated {
            infos.append(ResourceInfoTuple(value: dateFormatter.stringFromDate(lastUpdated), "Last Updated:"))
        }
        
        if (platform?.description != nil) {
            infos.append(ResourceInfoTuple(value: "Tap to view", label: "Description:"))
        }
        
        cell.textLabel?.attributedText = createResourceInfoString(infos)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let description = platform?.description else {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            return
        }
        
        showWebViewController(description)
    }
}