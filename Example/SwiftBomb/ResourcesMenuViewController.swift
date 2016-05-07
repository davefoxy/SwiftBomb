//
//  ResourcesMenuViewController.swift
//  GBAPI
//
//  Created by David Fox on 26/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation
import UIKit
import SwiftBomb

class ResourcesMenuViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Resources"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "searchResults") {
            return
        }
        
        let resourcesList = segue.destinationViewController as! ResourcesListViewController
        
        if (segue.identifier == "videos") {
            resourcesList.title = "Videos"
            resourcesList.resourcePaginator = VideoResourcePaginator(sort: SortDefinition(field: "publish_date", direction: .Descending))
        }
        else if (segue.identifier == "characters") {
            resourcesList.title = "Characters"
            resourcesList.resourcePaginator = CharactersResourcePaginator(sort: SortDefinition(field: "name", direction: .Ascending))
        }
        else if (segue.identifier == "games") {
            resourcesList.title = "Games"
            resourcesList.resourcePaginator = GameResourcePaginator(sort: SortDefinition(field: "name", direction: .Ascending))
        }
        else if (segue.identifier == "companies") {
            resourcesList.title = "Companies"
            resourcesList.resourcePaginator = CompanyResourcePaginator(sort: SortDefinition(field: "name", direction: .Ascending))
        }
        else if (segue.identifier == "concepts") {
            resourcesList.title = "Concepts"
            resourcesList.resourcePaginator = ConceptResourcePaginator(sort: SortDefinition(field: "name", direction: .Ascending))
        }
        else if (segue.identifier == "franchises") {
            resourcesList.title = "Franchises"
            resourcesList.resourcePaginator = FranchiseResourcePaginator(sort: SortDefinition(field: "name", direction: .Ascending))
        }
        else if (segue.identifier == "genres") {
            resourcesList.title = "Genres"
            resourcesList.resourcePaginator = GenreResourcePaginator(sort: SortDefinition(field: "name", direction: .Ascending))
        }
        else if (segue.identifier == "locations") {
            resourcesList.title = "Locations"
            resourcesList.resourcePaginator = LocationResourcePaginator(sort: SortDefinition(field: "name", direction: .Ascending))
        }
        else if (segue.identifier == "objects") {
            resourcesList.title = "Objects"
            resourcesList.resourcePaginator = ObjectResourcePaginator(sort: SortDefinition(field: "name", direction: .Ascending))
        }
        else if (segue.identifier == "people") {
            resourcesList.title = "People"
            resourcesList.resourcePaginator = PersonResourcePaginator(sort: SortDefinition(field: "name", direction: .Ascending))
        }
        else if (segue.identifier == "accessories") {
            resourcesList.title = "Accessories"
            resourcesList.resourcePaginator = AccessoryResourcePaginator(sort: SortDefinition(field: "name", direction: .Ascending))
        }
    }
}