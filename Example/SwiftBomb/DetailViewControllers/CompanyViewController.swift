//
//  CompanyViewController.swift
//  SwiftBomb
//
//  Created by David Fox on 07/05/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation
import UIKit
import SwiftBomb

class CompanyViewController: BaseResourceDetailViewController {
    
    var company: CompanyResource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        company?.fetchExtendedInfo() { [weak self] error in
            
            self?.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 0 ? 1 : 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        
        var title = ""
        if (indexPath as NSIndexPath).section == 0 {
            
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .byWordWrapping
            
            var infos = [ResourceInfoTuple(value: company?.name, "Name:"), ResourceInfoTuple(value: company?.deck, "Deck:"), ResourceInfoTuple(value: company?.aliases?.joined(separator: ", "), "Aliases:")]
            
            if let dateAdded = company?.date_added {
                infos.append(ResourceInfoTuple(value: dateFormatter.string(from: dateAdded), "Date Added:"))
            }
            
            if let lastUpdated = company?.date_last_updated {
                infos.append(ResourceInfoTuple(value: dateFormatter.string(from: lastUpdated), "Last Updated:"))
            }
            
            if let dateFounded = company?.date_founded {
                infos.append(ResourceInfoTuple(value: dateFormatter.string(from: dateFounded), "Date Founded:"))
            }
            
            if let phone = company?.phone {
                infos.append(ResourceInfoTuple(value: phone, "Phone:"))
            }
            
            if let website = company?.website {
                infos.append(ResourceInfoTuple(value: website.absoluteString, "Website:"))
            }
            
            if (company?.description != nil) {
                infos.append(ResourceInfoTuple(value: "Tap to view", label: "Description:"))
            }
            
            cell.textLabel?.attributedText = createResourceInfoString(infos)
            
            return cell
        }
        else {
            switch (indexPath as NSIndexPath).row {
            case 0:
                if let developedGames = company?.extendedInfo?.developed_games {
                    title = "Developed Games (\(developedGames.count))"
                }
                
            case 1:
                if let publishedGames = company?.extendedInfo?.published_games {
                    title = "Published Games (\(publishedGames.count))"
                }
                
            case 2:
                if let people = company?.extendedInfo?.people {
                    title = "People (\(people.count))"
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
            guard let description = company?.description else {
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
                // developed games
                let gamesPaginator = GameResourcePaginator()
                gamesPaginator.games = (company?.extendedInfo?.developed_games)!
                resourcesList.resourcePaginator = gamesPaginator
                resourcesList.cellPresenters = gamesPaginator.cellPresentersForResources((company?.extendedInfo?.developed_games)!)
                
            case 1:
                // published games
                let gamesPaginator = GameResourcePaginator()
                gamesPaginator.games = (company?.extendedInfo?.published_games)!
                resourcesList.resourcePaginator = gamesPaginator
                resourcesList.cellPresenters = gamesPaginator.cellPresentersForResources((company?.extendedInfo?.published_games)!)
                
            case 2:
                // people
                let personPaginator = PersonResourcePaginator()
                personPaginator.people = (company?.extendedInfo?.people)!
                resourcesList.resourcePaginator = personPaginator
                resourcesList.cellPresenters = personPaginator.cellPresentersForResources((company?.extendedInfo?.people)!)
                
            default:
                break
            }
            
            navigationController?.pushViewController(resourcesList, animated: true)
        }
    }
}
