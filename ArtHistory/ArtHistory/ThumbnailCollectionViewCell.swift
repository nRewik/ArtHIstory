//
//  ThumbnailCollectionViewCell.swift
//  ArtHistory
//
//  Created by Nutchaphon Rewik on 7/12/15.
//  Copyright (c) 2015 Nutchaphon Rewik. All rights reserved.
//

import UIKit

class ThumbnailCollectionViewCell: UICollectionViewCell {
    
    var action: ( () -> Void )?
    var image: UIImage?{
        didSet{
            layoutIfNeeded()
            button.setImage(image, forState: .Normal)
            button.layer.cornerRadius = button.frame.width / 2.0
            button.clipsToBounds = true
        }
    }
    @IBOutlet weak private var button: UIButton!
    
    @IBAction func buttonPressed() {
        action?()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        action = nil
    }
}
