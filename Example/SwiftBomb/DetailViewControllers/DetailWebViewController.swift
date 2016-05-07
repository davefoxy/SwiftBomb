//
//  DetailWebViewController.swift
//  SwiftBomb
//
//  Created by David Fox on 07/05/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class DetailWebViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    var htmlContent: String?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        guard let htmlContent = htmlContent else {
            return
        }
        
        webView.loadHTMLString(htmlContent, baseURL: nil)
    }
}