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
    
    func showWebViewController(html: String) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let webViewController = storyboard.instantiateViewControllerWithIdentifier("DetailWebViewController") as! DetailWebViewController
        webViewController.htmlContent = html
        
        navigationController?.pushViewController(webViewController, animated: true)
    }
}