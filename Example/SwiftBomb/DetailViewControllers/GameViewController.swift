//
//  GameViewController.swift
//  SwiftBomb
//
//  Created by David Fox on 07/05/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation
import UIKit
import SwiftBomb

class GameViewController: BaseResourceDetailViewController {
    
    var game: GameResource?
    
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
        
        return section == 0 ? 1 : 4
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        var title = ""
        if indexPath.section == 0 {
            
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .ByWordWrapping
            
            var infos = [ResourceInfoTuple(value: game?.name, "Name:"), ResourceInfoTuple(value: game?.deck, "Deck:"), ResourceInfoTuple(value: game?.aliases?.joinWithSeparator(", "), "Aliases:")]
            
            if game?.platforms?.count > 0 {
                
                let platformNames = game?.platforms?.map({ $0.name ?? "" })
                infos.append(ResourceInfoTuple(value: platformNames?.joinWithSeparator(", "), label: "Platforms:"))
            }
            
            if let dateAdded = game?.date_added {
                infos.append(ResourceInfoTuple(value: dateFormatter.stringFromDate(dateAdded), "Date Added:"))
            }
            
            if let lastUpdated = game?.date_last_updated {
                infos.append(ResourceInfoTuple(value: dateFormatter.stringFromDate(lastUpdated), "Last Updated:"))
            }
            
            if (game?.description != nil) {
                infos.append(ResourceInfoTuple(value: "Tap to view", label: "Description:"))
            }
            
            cell.textLabel?.attributedText = createResourceInfoString(infos)
            
            return cell
        }
        else {
            switch indexPath.row {
            case 0:
                if let characters = game?.extendedInfo?.characters {
                    title = "Characters (\(characters.count))"
                }
                
            case 1:
                if let developers = game?.extendedInfo?.developers {
                    title = "Developers (\(developers.count))"
                }
                
            case 2:
                if let people = game?.extendedInfo?.people {
                    title = "People (\(people.count))"
                }
                
            case 3:
                if let publishers = game?.extendedInfo?.publishers {
                    title = "Publishers (\(publishers.count))"
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
            guard let description = game?.description else {
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
                charactersPaginator.characters = (game?.extendedInfo?.characters)!
                resourcesList.resourcePaginator = charactersPaginator
                resourcesList.cellPresenters = charactersPaginator.cellPresentersForResources((game?.extendedInfo?.characters)!)
                
            case 1:
                // developers
                let companyPaginator = CompanyResourcePaginator()
                companyPaginator.companies = (game?.extendedInfo?.developers)!
                resourcesList.resourcePaginator = companyPaginator
                resourcesList.cellPresenters = companyPaginator.cellPresentersForResources((game?.extendedInfo?.developers)!)
                
            case 2:
                // people
                let personPaginator = PersonResourcePaginator()
                personPaginator.people = (game?.extendedInfo?.people)!
                resourcesList.resourcePaginator = personPaginator
                resourcesList.cellPresenters = personPaginator.cellPresentersForResources((game?.extendedInfo?.people)!)
                
            case 3:
                // publishers
                let companyPaginator = CompanyResourcePaginator()
                companyPaginator.companies = (game?.extendedInfo?.publishers)!
                resourcesList.resourcePaginator = companyPaginator
                resourcesList.cellPresenters = companyPaginator.cellPresentersForResources((game?.extendedInfo?.publishers)!)
                
            default:
                break
            }
            
            navigationController?.pushViewController(resourcesList, animated: true)
        }
    }
}