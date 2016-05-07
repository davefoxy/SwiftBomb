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
        
        thumbnailImageView.image = nil
    }
    
    func updateFromPresenter(presenter: ResourceItemCellPresenter) {
        
        titleLabel.text = presenter.title
        subtitleLabel.text = presenter.subtitle
        
        if let thumbURL = presenter.imageURL {
            thumbnailImageView.load(thumbURL)
        }
    }
}