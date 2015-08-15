//
//  LessonContentTableViewCell.swift
//  ArtHistory
//
//  Created by Nutchaphon Rewik on 8/8/15.
//  Copyright (c) 2015 Nutchaphon Rewik. All rights reserved.
//

import UIKit

class LessonContentTableViewCell: UITableViewCell {

    
    var contentText: String?{
        didSet{
            contentLabel.text = contentText
        }
    }
    
    @IBOutlet private weak var contentLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
