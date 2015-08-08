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
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
         super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
