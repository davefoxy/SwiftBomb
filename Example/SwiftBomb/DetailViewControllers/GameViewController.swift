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
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 0 ? 1 : 7
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        var title = ""
        if indexPath.section == 0 {
            
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .ByWordWrapping
            
            var infos = []//ResourceInfoTuple(value: game?.platforms, "Platforms:")]
            
            
//            cell.textLabel?.attributedText = createResourceInfoString(infos)
            
            return cell
        }
        else {
            switch indexPath.row {
            case 0:
                if let platforms = game?.platforms {
                    title = "Platforms (\(platforms.count))"
                }
                
            case 1:
                if let characters = game?.extendedInfo?.characters {
                    title = "Characters (\(characters.count))"
                }
                
            case 2:
                if let concepts = game?.extendedInfo?.concepts {
                    title = "Concepts (\(concepts.count))"
                }
                
            case 3:
                if let developers = game?.extendedInfo?.developers {
                    title = "Developers (\(developers.count))"
                }
                
            case 4:
                if let firstAppearanceCharacters = game?.extendedInfo?.first_appearance_characters {
                    title = "First Appearance Characters (\(firstAppearanceCharacters.count))"
                }
                
            case 5:
                if let firstAppearancePeople = game?.extendedInfo?.first_appearance_people {
                    title = "First Appearance People (\(firstAppearancePeople.count))"
                }
                
            case 6:
                if let people = game?.extendedInfo?.people {
                    title = "People (\(people.count))"
                }
                
            default:
                break
            }
        }
        
        cell.textLabel?.text = title
        
        return cell
    }
}