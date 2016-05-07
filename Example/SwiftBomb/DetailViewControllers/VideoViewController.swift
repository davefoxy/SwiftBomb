//
//  VideoViewController.swift
//  SwiftBomb
//
//  Created by David Fox on 07/05/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
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
        
        var infos = [ResourceInfoTuple(value: video?.name, "Name:"), ResourceInfoTuple(value: video?.deck, "Deck:")]
        
        if let publishDate = video?.publish_date {
            infos.append(ResourceInfoTuple(value: dateFormatter.stringFromDate(publishDate), "Publish Date:"))
        }
        
        let minutesDuration = (video?.length_seconds)! / 60
        let lengthString = "\(minutesDuration) minutes"
        infos.append(ResourceInfoTuple(value: lengthString, "Duration:"))
        
        cell.textLabel?.attributedText = createResourceInfoString(infos)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}