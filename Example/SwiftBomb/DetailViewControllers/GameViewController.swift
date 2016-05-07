//
//  GameViewController.swift
//  SwiftBomb
//
//  Created by David Fox on 07/05/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SwiftBomb

class GameViewController: BaseResourceDetailViewController {
    
    var game: GBGameResource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        game?.fetchExtendedInfo() { [weak self] error in
            
            self?.tableView.reloadData()
        }
    }
    
    
}