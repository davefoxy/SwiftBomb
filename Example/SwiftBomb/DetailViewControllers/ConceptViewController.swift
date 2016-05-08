//
//  ConceptViewController.swift
//  SwiftBomb
//
//  Created by David Fox on 07/05/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation
import UIKit
import SwiftBomb

class ConceptViewController: BaseResourceDetailViewController {
    
    var concept: ConceptResource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        concept?.fetchExtendedInfo() { [weak self] error in
            
            self?.tableView.reloadData()
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 0 ? 1 : 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        var title = ""
        if indexPath.section == 0 {
            
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .ByWordWrapping
            
            var infos = [ResourceInfoTuple(value: concept?.name, "Name:"), ResourceInfoTuple(value: concept?.deck, "Deck:"), ResourceInfoTuple(value: concept?.aliases?.joinWithSeparator(", "), "Aliases:")]
            
            if let dateAdded = concept?.date_added {
                infos.append(ResourceInfoTuple(value: dateFormatter.stringFromDate(dateAdded), "Date Added:"))
            }
            
            if let lastUpdated = concept?.date_last_updated {
                infos.append(ResourceInfoTuple(value: dateFormatter.stringFromDate(lastUpdated), "Last Updated:"))
            }
            
            if (concept?.description != nil) {
                infos.append(ResourceInfoTuple(value: "Tap to view", label: "Description:"))
            }
            
            cell.textLabel?.attributedText = createResourceInfoString(infos)
            
            return cell
        }
        else {
            switch indexPath.row {
            case 0:
                if let characters = concept?.extendedInfo?.characters {
                    title = "Related Characters (\(characters.count))"
                }
                
            case 1:
                if let games = concept?.extendedInfo?.games {
                    title = "Related Games (\(games.count))"
                }
                
            case 2:
                if let characters = concept?.extendedInfo?.characters {
                    title = "Related Characters (\(characters.count))"
                }
                
            default:
                break
            }
        }
        
        cell.textLabel?.text = title
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 {
            guard let description = concept?.description else {
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
                return
            }
            
            showWebViewController(description)
        }
        else {
            
            let resourcesList = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ResourcesListViewController") as! ResourcesListViewController
            resourcesList.shouldLoadFromServer = false
            
            switch indexPath.row {
            case 0:
                // characters
                let charactersPaginator = CharactersResourcePaginator()
                charactersPaginator.characters = (concept?.extendedInfo?.characters)!
                resourcesList.resourcePaginator = charactersPaginator
                resourcesList.cellPresenters = charactersPaginator.cellPresentersForResources((concept?.extendedInfo?.characters)!)
                
            case 1:
                // related games
                let gamesPaginator = GameResourcePaginator()
                gamesPaginator.games = (concept?.extendedInfo?.games)!
                resourcesList.resourcePaginator = gamesPaginator
                resourcesList.cellPresenters = gamesPaginator.cellPresentersForResources((concept?.extendedInfo?.games)!)
                
            case 2:
                // people
                let personPaginator = PersonResourcePaginator()
                personPaginator.people = (concept?.extendedInfo?.people)!
                resourcesList.resourcePaginator = personPaginator
                resourcesList.cellPresenters = personPaginator.cellPresentersForResources((concept?.extendedInfo?.people)!)
                
            default:
                break
            }
            
            navigationController?.pushViewController(resourcesList, animated: true)
        }
    }
}