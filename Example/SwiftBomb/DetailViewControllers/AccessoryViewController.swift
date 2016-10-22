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
    
    var accessory: AccessoryResource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accessory?.fetchExtendedInfo() { [weak self] error in
            
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
        
        var infos = [ResourceInfoTuple(value: accessory?.name, "Name:"), ResourceInfoTuple(value: accessory?.deck, "Deck:")]
        
        if let dateAdded = accessory?.date_added {
            infos.append(ResourceInfoTuple(value: dateFormatter.string(from: dateAdded), "Date Added:"))
        }
        
        if let lastUpdated = accessory?.date_last_updated {
            infos.append(ResourceInfoTuple(value: dateFormatter.string(from: lastUpdated), "Last Updated:"))
        }
        
        if (accessory?.description != nil) {
            infos.append(ResourceInfoTuple(value: "Tap to view", label: "Description:"))
        }
        
        cell.textLabel?.attributedText = createResourceInfoString(infos)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let description = accessory?.description else {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        showWebViewController(description)
    }
}
