//
//  CompanyViewController.swift
//  SwiftBomb
//
//  Created by David Fox on 07/05/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SwiftBomb

class CompanyViewController: BaseResourceDetailViewController {
    
    var company: GBCompanyResource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        company?.fetchExtendedInfo() { [weak self] error in
            
            self?.tableView.reloadData()
        }
    }
    
    
}