//
//  PersonViewController.swift
//  SwiftBomb
//
//  Created by David Fox on 07/05/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SwiftBomb

class PersonViewController: BaseResourceDetailViewController {
    
    var person: PersonResource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        person?.fetchExtendedInfo() { [weak self] error in
            
            self?.tableView.reloadData()
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 0 ? 1 : 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        var title = ""
        if indexPath.section == 0 {
            
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .ByWordWrapping
            
            var infos = [ResourceInfoTuple(value: person?.name, "Name:"), ResourceInfoTuple(value: person?.deck, "Deck:"), ResourceInfoTuple(value: person?.gender?.description, "Gender:"), ResourceInfoTuple(value: person?.aliases?.joinWithSeparator(", "), "Aliases:")]
            
            if let birthday = person?.birth_date {
                infos.append(ResourceInfoTuple(value: dateFormatter.stringFromDate(birthday), "Birthday:"))
            }
            
            if let firstCreditedGame = person?.first_credited_game {
                infos.append(ResourceInfoTuple(value: firstCreditedGame.name, "First Credited Game:"))
            }
            
            if let dateAdded = person?.date_added {
                infos.append(ResourceInfoTuple(value: dateFormatter.stringFromDate(dateAdded), "Date Added:"))
            }
            
            if let lastUpdated = person?.date_last_updated {
                infos.append(ResourceInfoTuple(value: dateFormatter.stringFromDate(lastUpdated), "Last Updated:"))
            }
            
            if (person?.description != nil) {
                infos.append(ResourceInfoTuple(value: "Tap to view", label: "Description:"))
            }
            
            cell.textLabel?.attributedText = createResourceInfoString(infos)
            
            return cell
        }
        else {
            switch indexPath.row {
            case 0:
                if let games = person?.extendedInfo?.games {
                    title = "Games (\(games.count))"
                }
                
            case 1:
                if let associatedPeople = person?.extendedInfo?.people {
                    title = "Associated People (\(associatedPeople.count))"
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
            guard let description = person?.description else {
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
                // developed games
                let gamesPaginator = GameResourcePaginator()
                gamesPaginator.games = (person?.extendedInfo?.games)!
                resourcesList.resourcePaginator = gamesPaginator
                resourcesList.cellPresenters = gamesPaginator.cellPresentersForResources((person?.extendedInfo?.games)!)
                
            case 1:
                // associated people
                let personPaginator = PersonResourcePaginator()
                personPaginator.people = (person?.extendedInfo?.people)!
                resourcesList.resourcePaginator = personPaginator
                resourcesList.cellPresenters = personPaginator.cellPresentersForResources((person?.extendedInfo?.people)!)
                
            default:
                break
            }
            
            navigationController?.pushViewController(resourcesList, animated: true)
        }
    }
}