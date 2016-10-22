//
//  FranchiseViewController.swift
//  SwiftBomb
//
//  Created by David Fox on 07/05/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import UIKit
import SwiftBomb

class FranchiseViewController: BaseResourceDetailViewController {
    
    var franchise: FranchiseResource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        franchise?.fetchExtendedInfo() { [weak self] error in
            
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
            
            var infos = [ResourceInfoTuple(value: franchise?.name, "Name:"), ResourceInfoTuple(value: franchise?.deck, "Deck:"), ResourceInfoTuple(value: franchise?.aliases?.joined(separator: ", "), "Aliases:")]
            
            if (franchise?.description != nil) {
                infos.append(ResourceInfoTuple(value: "Tap to view", label: "Description:"))
            }
            
            cell.textLabel?.attributedText = createResourceInfoString(infos)
            
            return cell
        }
        else {
            switch (indexPath as NSIndexPath).row {
            case 0:
                if let games = franchise?.extendedInfo?.games {
                    title = "Games (\(games.count))"
                }
                
            case 1:
                if let characters = franchise?.extendedInfo?.characters {
                    title = "Characters (\(characters.count))"
                }
                
            case 2:
                if let people = franchise?.extendedInfo?.people {
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
            guard let description = franchise?.description else {
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
                // games
                let gamesPaginator = GameResourcePaginator()
                gamesPaginator.games = (franchise?.extendedInfo?.games)!
                resourcesList.resourcePaginator = gamesPaginator
                resourcesList.cellPresenters = gamesPaginator.cellPresentersForResources((franchise?.extendedInfo?.games)!)
                
            case 1:
                // characters
                let charactersPaginator = CharactersResourcePaginator()
                charactersPaginator.characters = (franchise?.extendedInfo?.characters)!
                resourcesList.resourcePaginator = charactersPaginator
                resourcesList.cellPresenters = charactersPaginator.cellPresentersForResources((franchise?.extendedInfo?.characters)!)
                
            case 2:
                // people
                let personPaginator = PersonResourcePaginator()
                personPaginator.people = (franchise?.extendedInfo?.people)!
                resourcesList.resourcePaginator = personPaginator
                resourcesList.cellPresenters = personPaginator.cellPresentersForResources((franchise?.extendedInfo?.people)!)
                
            default:
                break
            }
            
            navigationController?.pushViewController(resourcesList, animated: true)
        }
    }
}
