//
//  Lesson.swift
//  ArtHistory
//
//  Created by Nutchaphon Rewik on 7/12/15.
//  Copyright (c) 2015 Nutchaphon Rewik. All rights reserved.
//

import UIKit

struct Lesson {
    var title = "Title"
    var detail = "detail..."
    var image: UIImage?
    
    static func getImageFromIndex(index: Int) -> UIImage{
        return UIImage(named: "\(index%5)")!
    }
}