//
//  CharacterViewController.swift
//  GBAPI
//
//  Created by David Fox on 24/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation
import UIKit
import SwiftBomb

class CharacterViewController: BaseResourceDetailViewController {
    
    var character: CharacterResource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        character?.fetchExtendedInfo() { [weak self] error in
            
            self?.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 0 ? 1 : 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        
        var title = ""
        if (indexPath as NSIndexPath).section == 0 {
            
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .byWordWrapping
            
            var infos = [ResourceInfoTuple(value: character?.name, "Name:"), ResourceInfoTuple(value: character?.deck, "Deck:"), ResourceInfoTuple(value: character?.gender?.description, "Gender:"), ResourceInfoTuple(value: character?.aliases?.joined(separator: ", "), "Aliases:")]
            
            if let birthday = character?.birthday {
                infos.append(ResourceInfoTuple(value: dateFormatter.string(from: birthday), "Birthday:"))
            }
            
            if let dateAdded = character?.date_added {
                infos.append(ResourceInfoTuple(value: dateFormatter.string(from: dateAdded), "Date Added:"))
            }
            
            if let lastUpdated = character?.date_last_updated {
                infos.append(ResourceInfoTuple(value: dateFormatter.string(from: lastUpdated), "Last Updated:"))
            }
            
            if (character?.description != nil) {
                infos.append(ResourceInfoTuple(value: "Tap to view", label: "Description:"))
            }
            
            cell.textLabel?.attributedText = createResourceInfoString(infos)
            
            return cell
        }
        else {
            switch (indexPath as NSIndexPath).row {
            case 0:
                if let games = character?.extendedInfo?.games {
                    title = "Games (\(games.count))"
                }
                
            case 1:
                if let franchises = character?.extendedInfo?.franchises {
                    title = "Franchises (\(franchises.count))"
                }
                
            case 2:
                if let friends = character?.extendedInfo?.friends {
                    title = "Friends (\(friends.count))"
                }
                
            case 3:
                if let enemies = character?.extendedInfo?.enemies {
                    title = "Enemies (\(enemies.count))"
                }
                
            case 4:
                if let people = character?.extendedInfo?.people {
                    title = "Related People (\(people.count))"
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
            guard let description = character?.description else {
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
                let gamesPaginator = GameResourcePaginator(sort: SortDefinition(field: "name", direction: .ascending))
                gamesPaginator.games = (character?.extendedInfo?.games)!
                resourcesList.resourcePaginator = gamesPaginator
                resourcesList.cellPresenters = gamesPaginator.cellPresentersForResources((character?.extendedInfo?.games)!)
                
            case 1:
                // franchises
                let franchisesPaginator = FranchiseResourcePaginator(sort: SortDefinition(field: "name", direction: .ascending))
                franchisesPaginator.franchises = (character?.extendedInfo?.franchises)!
                resourcesList.resourcePaginator = franchisesPaginator
                resourcesList.cellPresenters = franchisesPaginator.cellPresentersForResources((character?.extendedInfo?.franchises)!)
                
            case 2:
                // friends
                let charactersPaginator = CharactersResourcePaginator()
                charactersPaginator.characters = (character?.extendedInfo?.friends)!
                resourcesList.resourcePaginator = charactersPaginator
                resourcesList.cellPresenters = charactersPaginator.cellPresentersForResources((character?.extendedInfo?.friends)!)
                
            case 3:
                // enemies
                let charactersPaginator = CharactersResourcePaginator()
                charactersPaginator.characters = (character?.extendedInfo?.enemies)!
                resourcesList.resourcePaginator = charactersPaginator
                resourcesList.cellPresenters = charactersPaginator.cellPresentersForResources((character?.extendedInfo?.enemies)!)
                
            case 4:
                // people
                let personPaginator = PersonResourcePaginator()
                personPaginator.people = (character?.extendedInfo?.people)!
                resourcesList.resourcePaginator = personPaginator
                resourcesList.cellPresenters = personPaginator.cellPresentersForResources((character?.extendedInfo?.people)!)
                
            default:
            break
            }
            
            navigationController?.pushViewController(resourcesList, animated: true)
        }
    }
    
}
