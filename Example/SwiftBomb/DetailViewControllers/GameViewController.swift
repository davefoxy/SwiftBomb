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
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class GameViewController: BaseResourceDetailViewController {
    
    var game: GameResource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        game?.fetchExtendedInfo() { [weak self] error in
            
            self?.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 0 ? 1 : 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        
        var title = ""
        if (indexPath as NSIndexPath).section == 0 {
            
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .byWordWrapping
            
            var infos = [ResourceInfoTuple(value: game?.name, "Name:"), ResourceInfoTuple(value: game?.deck, "Deck:"), ResourceInfoTuple(value: game?.aliases?.joined(separator: ", "), "Aliases:")]
            
            if game?.platforms?.count > 0 {
                
                let platformNames = game?.platforms?.map({ $0.name ?? "" })
                infos.append(ResourceInfoTuple(value: platformNames?.joined(separator: ", "), label: "Platforms:"))
            }
            
            if let dateAdded = game?.date_added {
                infos.append(ResourceInfoTuple(value: dateFormatter.string(from: dateAdded), "Date Added:"))
            }
            
            if let lastUpdated = game?.date_last_updated {
                infos.append(ResourceInfoTuple(value: dateFormatter.string(from: lastUpdated), "Last Updated:"))
            }
            
            if (game?.description != nil) {
                infos.append(ResourceInfoTuple(value: "Tap to view", label: "Description:"))
            }
            
            cell.textLabel?.attributedText = createResourceInfoString(infos)
            
            return cell
        }
        else {
            switch (indexPath as NSIndexPath).row {
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath as NSIndexPath).section == 0 {
            guard let description = game?.description else {
                tableView.deselectRow(at: indexPath, animated: true)
                return
            }
            
            showWebViewController(description)
        }
        else {
            
            let resourcesList = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ResourcesListViewController") as! ResourcesListViewController
            resourcesList.shouldLoadFromServer = false
            
            switch (indexPath as NSIndexPath).row {
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
