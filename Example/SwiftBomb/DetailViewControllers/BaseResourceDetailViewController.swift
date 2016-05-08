//
//  BaseResourceDetailViewController.swift
//  SwiftBomb
//
//  Created by David Fox on 07/05/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation
import UIKit

typealias ResourceInfoTuple = (value: String?, label: String)

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

    func createResourceInfoString(infos: [ResourceInfoTuple]) -> NSMutableAttributedString {
        
        var infoString = NSMutableAttributedString()
        
        for info in infos {
            
            if let value = info.value {
                updateInfo(&infoString, label: info.label, value: value)
            }
        }
        
        return infoString
    }
    
    func updateInfo(inout info: NSMutableAttributedString, label: String, value: String) {
        
        info.mutableString.appendString("\(label) \(value)\n")
        info.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(17), range: info.mutableString.rangeOfString(label))
    }
}