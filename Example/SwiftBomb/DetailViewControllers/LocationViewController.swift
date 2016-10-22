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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 0 ? 1 : 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        
        var infos = [ResourceInfoTuple(value: location?.name, "Name:"), ResourceInfoTuple(value: location?.deck, "Deck:"), ResourceInfoTuple(value: location?.aliases?.joined(separator: ", "), "Aliases:")]
        
        if let dateAdded = location?.date_added {
            infos.append(ResourceInfoTuple(value: dateFormatter.string(from: dateAdded), "Date Added:"))
        }
        
        if let lastUpdated = location?.date_last_updated {
            infos.append(ResourceInfoTuple(value: dateFormatter.string(from: lastUpdated), "Last Updated:"))
        }
        
        if (location?.description != nil) {
            infos.append(ResourceInfoTuple(value: "Tap to view", label: "Description:"))
        }
        
        cell.textLabel?.attributedText = createResourceInfoString(infos)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let description = location?.description else {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        showWebViewController(description)
        
    }
}
