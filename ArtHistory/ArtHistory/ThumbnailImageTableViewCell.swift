//
//  ThumbnailImageTableViewCell.swift
//  ArtHistory
//
//  Created by Nutchaphon Rewik on 8/8/15.
//  Copyright (c) 2015 Nutchaphon Rewik. All rights reserved.
//

import UIKit

class ThumbnailImageTableViewCell: UITableViewCell {

    var thumbnailImage: UIImage?{
        didSet{
            thumbnailImageView?.image = thumbnailImage
        }
    }
    var title: String?{
        didSet{
            titleLabel?.text = title
//            layoutIfNeeded()
        }
    }
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contentView.layer.shadowColor = UIColor.blackColor().CGColor
        contentView.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
        contentView.layer.shadowRadius = 1.0
        contentView.layer.shadowOpacity = 0.2
        
        cardView.layer.cornerRadius = 2.5
    }

    override func setSelected(selected: Bool, animated: Bool) {
         super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
