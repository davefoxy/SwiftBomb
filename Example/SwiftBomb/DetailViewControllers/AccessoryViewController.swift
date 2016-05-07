//
//  AccessoryViewController.swift
//  GBAPI
//
//  Created by David Fox on 01/05/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation
import UIKit
import SwiftBomb

class AccessoryViewController: BaseResourceDetailViewController {
    
    var accessory: GBAccessoryResource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = accessory?.name
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
        
        var infos = [ResourceInfoTuple(value: accessory?.name, "Name:"), ResourceInfoTuple(value: accessory?.deck, "Deck:")]
        
        if let dateAdded = accessory?.date_added {
            infos.append(ResourceInfoTuple(value: dateFormatter.stringFromDate(dateAdded), "Date Added:"))
        }
        
        if let lastUpdated = accessory?.date_last_updated {
            infos.append(ResourceInfoTuple(value: dateFormatter.stringFromDate(lastUpdated), "Last Updated:"))
        }
        
        if (accessory?.description != nil) {
            infos.append(ResourceInfoTuple(value: "Tap to view", label: "Description:"))
        }
        
        cell.textLabel?.attributedText = createResourceInfoString(infos)
        
        return cell
    }
}