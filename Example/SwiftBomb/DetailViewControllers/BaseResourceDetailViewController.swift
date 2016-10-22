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
    
    let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50

        dateFormatter.dateStyle = .medium
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    func showWebViewController(_ html: String) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let webViewController = storyboard.instantiateViewController(withIdentifier: "DetailWebViewController") as! DetailWebViewController
        webViewController.htmlContent = html
        
        navigationController?.pushViewController(webViewController, animated: true)
    }

    func createResourceInfoString(_ infos: [ResourceInfoTuple]) -> NSMutableAttributedString {
        
        var infoString = NSMutableAttributedString()
        
        for info in infos {
            
            if let value = info.value {
                updateInfo(&infoString, label: info.label, value: value)
            }
        }
        
        return infoString
    }
    
    func updateInfo(_ info: inout NSMutableAttributedString, label: String, value: String) {
        
        info.mutableString.append("\(label) \(value)\n")
        info.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 17), range: info.mutableString.range(of: label))
    }
}
