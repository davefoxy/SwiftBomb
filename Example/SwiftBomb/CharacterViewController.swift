//
//  CharacterViewController.swift
//  GBAPI
//
//  Created by David Fox on 24/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation
import UIKit

class CharacterViewController: UITableViewController {
    
    var character: GBCharacterResource?
    let dateFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
        dateFormatter.dateStyle = .MediumStyle
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        character?.fetchExtendedInfo() { [weak self] error in
            
            self?.tableView.reloadData()
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        guard let character = character else {
            return 0
        }
        
        guard (character.extendedInfo) != nil else {
            return 1
        }
        
        return 9
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "INFO"
            
        case 1:
            return "GAMES"
            
        case 2:
            return "FRANCHISES"
            
        case 3:
            return "FRIENDS"
            
        case 4:
            return "ENEMIES"
            
        case 5:
            return "PEOPLE"
            
        case 6:
            return "CONCEPTS"
            
        case 7:
            return "LOCATIONS"
            
        case 8:
            return "OBJECTS"
            
        default:
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 8
            
        case 1:
            return (character?.extendedInfo?.games.count)!
            
        case 2:
            return (character?.extendedInfo?.franchises.count)!
            
        case 3:
            return (character?.extendedInfo?.friends.count)!
            
        case 4:
            return (character?.extendedInfo?.enemies.count)!
            
        case 5:
            return (character?.extendedInfo?.people.count)!
            
        case 6:
            return (character?.extendedInfo?.concepts.count)!
            
        case 7:
            return (character?.extendedInfo?.locations.count)!
            
        case 8:
            return (character?.extendedInfo?.objects.count)!
            
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        var title = ""
        switch indexPath.section {
        case 0:
            // name, aliases, birthday, date_added, date_last_updated, deck, description(html), gender,
            switch indexPath.row {
            case 0:
                var value = "Unknown"
                if let name = character?.name {
                    value = name
                }
                title = "Name: \(value)"
                
            case 1:
                var value = "Unknown"
                if let deck = character?.deck {
                    value = deck
                }
                title = "Deck: \(value)"
                
            case 2:
                var value = Gender.Unknown
                if let gender = character?.gender {
                    value = gender
                }
                title = "Gender: \(value)"
                
            case 3:
                var value = "Unavailable"
                if (character?.description != nil) {
                    value = "Read more..."
                }
                title = "Description: \(value)"
                
            case 4:
                var value = "Unknown"
                if let aliases = character?.aliases {
                    value = aliases.joinWithSeparator(", ")
                }
                title = "Aliases: \(value)"
                
            case 5:
                var value = "Unknown"
                if let birthday = character?.birthday {
                    value = dateFormatter.stringFromDate(birthday)
                }
                title = "Birthday: \(value)"
                
            case 6:
                var value = "Unknown"
                if let dateAdded = character?.date_added {
                    value = dateFormatter.stringFromDate(dateAdded)
                }
                title = "Date Added: \(value)"
                
            case 7:
                var value = "Unknown"
                if let lastUpdated = character?.date_last_updated {
                    value = dateFormatter.stringFromDate(lastUpdated)
                }
                title = "Date Last Updated: \(value)"
                
            default:
                break
            }
            
        case 1:
            title = (character?.extendedInfo?.games[indexPath.row].name)!
            
        case 2:
            title = (character?.extendedInfo?.franchises[indexPath.row].name)!
            
        case 3:
            title = (character?.extendedInfo?.friends[indexPath.row].name)!
            
        case 4:
            title = (character?.extendedInfo?.enemies[indexPath.row].name)!
            
        case 5:
            title = (character?.extendedInfo?.people[indexPath.row].name)!
            
        case 6:
            title = (character?.extendedInfo?.concepts[indexPath.row].name)!
            
        case 7:
            title = (character?.extendedInfo?.locations[indexPath.row].name)!
            
        case 8:
            title = (character?.extendedInfo?.objects[indexPath.row].name)!
            
        default:
            break
        }
        
        cell.textLabel?.text = title
        
        return cell
    }
    
    
}