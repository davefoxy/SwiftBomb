//
//  ObjectViewController.swift
//  SwiftBomb
//
//  Created by David Fox on 07/05/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation
import UIKit
import SwiftBomb

class ObjectViewController: BaseResourceDetailViewController {
    
    var object: ObjectResource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        object?.fetchExtendedInfo() { [weak self] error in
            
            self?.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 0 ? 1 : 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        
        var title = ""
        if (indexPath as NSIndexPath).section == 0 {
            
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .byWordWrapping
            
            var infos = [ResourceInfoTuple(value: object?.name, "Name:"), ResourceInfoTuple(value: object?.deck, "Deck:"), ResourceInfoTuple(value: object?.aliases?.joined(separator: ", "), "Aliases:")]
            
            if let dateAdded = object?.date_added {
                infos.append(ResourceInfoTuple(value: dateFormatter.string(from: dateAdded), "Date Added:"))
            }
            
            if let lastUpdated = object?.date_last_updated {
                infos.append(ResourceInfoTuple(value: dateFormatter.string(from: lastUpdated), "Last Updated:"))
            }
            
            if (object?.description != nil) {
                infos.append(ResourceInfoTuple(value: "Tap to view", label: "Description:"))
            }
            
            cell.textLabel?.attributedText = createResourceInfoString(infos)
            
            return cell
        }
        else {
            switch (indexPath as NSIndexPath).row {
            case 0:
                if let characters = object?.extendedInfo?.characters {
                    title = "Characters (\(characters.count))"
                }
                
            case 1:
                if let games = object?.extendedInfo?.games {
                    title = "Games (\(games.count))"
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
            guard let description = object?.description else {
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
                charactersPaginator.characters = (object?.extendedInfo?.characters)!
                resourcesList.resourcePaginator = charactersPaginator
                resourcesList.cellPresenters = charactersPaginator.cellPresentersForResources((object?.extendedInfo?.characters)!)
                
            case 1:
                // games
                let gamesPaginator = GameResourcePaginator()
                gamesPaginator.games = (object?.extendedInfo?.games)!
                resourcesList.resourcePaginator = gamesPaginator
                resourcesList.cellPresenters = gamesPaginator.cellPresentersForResources((object?.extendedInfo?.games)!)
                
            default:
                break
            }
            
            navigationController?.pushViewController(resourcesList, animated: true)
        }
    }
}
