//
//  Lesson.swift
//  ArtHistory
//
//  Created by Nutchaphon Rewik on 7/12/15.
//  Copyright (c) 2015 Nutchaphon Rewik. All rights reserved.
//

import UIKit

struct ArtHistory {
    
    var lessons = [Lesson]()
}


struct Lesson {
    
    var title = "Title"
    var detail = "detail..."
    var image: UIImage?
    
    var lessonGallery: [ArtHistoryImage]?
    
    static func getImageFromIndex(index: Int) -> UIImage{
        return UIImage(named: "\(index%5)")!
    }
}


struct ArtHistoryImage{
    
    var image: UIImage?
    var title = "Title"
    var subtitle = "Subtitle"
    
}

