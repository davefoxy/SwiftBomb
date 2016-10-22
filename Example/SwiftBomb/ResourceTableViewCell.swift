//
//  ResourceTableViewCell.swift
//  GBAPI
//
//  Created by David Fox on 20/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation
import UIKit

class ResourceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var cellPresenter: ResourceItemCellPresenter? {
        didSet {
            updateFromPresenter(cellPresenter!)
        }
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        thumbnailImageView.image = nil
    }
    
    func updateFromPresenter(_ presenter: ResourceItemCellPresenter) {
        
        titleLabel.text = presenter.title?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        subtitleLabel.text = presenter.subtitle?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if let thumbURL = presenter.imageURL {
            thumbnailImageView.load(thumbURL)
        } else {
            thumbnailImageView.image = UIImage(named: "PlaceholderCellImage")
        }
    }
}
