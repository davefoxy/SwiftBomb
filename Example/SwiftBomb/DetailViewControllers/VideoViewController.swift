//
//  VideoViewController.swift
//  SwiftBomb
//
//  Created by David Fox on 07/05/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation
import UIKit
import SwiftBomb

class VideoViewController: BaseResourceDetailViewController {
    
    var video: VideoResource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        video?.fetchExtendedInfo() { [weak self] error in
            
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
        
        var infos = [ResourceInfoTuple(value: video?.name, "Name:"), ResourceInfoTuple(value: video?.deck, "Deck:")]
        
        if let publishDate = video?.publish_date {
            infos.append(ResourceInfoTuple(value: dateFormatter.string(from: publishDate), "Publish Date:"))
        }
        
        let minutesDuration = (video?.length_seconds)! / 60
        let lengthString = "\(minutesDuration) minutes"
        infos.append(ResourceInfoTuple(value: lengthString, "Duration:"))
        
        cell.textLabel?.attributedText = createResourceInfoString(infos)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
