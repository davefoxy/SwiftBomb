//
//  LocationViewController.swift
//  SwiftBomb
//
//  Created by David Fox on 07/05/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation
import UIKit
import SwiftBomb

class LocationViewController: BaseResourceDetailViewController {
    
    var location: LocationResource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        location?.fetchExtendedInfo() { [weak self] error in
            
            self?.tableView.reloadData()
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 0 ? 1 : 4
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .ByWordWrapping
        
        var infos = [ResourceInfoTuple(value: location?.name, "Name:"), ResourceInfoTuple(value: location?.deck, "Deck:"), ResourceInfoTuple(value: location?.aliases?.joinWithSeparator(", "), "Aliases:")]
        
        if let dateAdded = location?.date_added {
            infos.append(ResourceInfoTuple(value: dateFormatter.stringFromDate(dateAdded), "Date Added:"))
        }
        
        if let lastUpdated = location?.date_last_updated {
            infos.append(ResourceInfoTuple(value: dateFormatter.stringFromDate(lastUpdated), "Last Updated:"))
        }
        
        if (location?.description != nil) {
            infos.append(ResourceInfoTuple(value: "Tap to view", label: "Description:"))
        }
        
        cell.textLabel?.attributedText = createResourceInfoString(infos)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let description = location?.description else {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            return
        }
        
        showWebViewController(description)
        
    }
}