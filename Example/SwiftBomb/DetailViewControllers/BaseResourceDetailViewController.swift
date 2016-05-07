//
//  BaseResourceDetailViewController.swift
//  SwiftBomb
//
//  Created by David Fox on 07/05/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class BaseResourceDetailViewController: UITableViewController {
    
    let dateFormatter = NSDateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50

        dateFormatter.dateStyle = .MediumStyle
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
}