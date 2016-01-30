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
    var imageName: String?
    var image: UIImage?{
        guard let imageName = imageName else { return nil }
        return UIImage(named: imageName)
    }
    
    var lessonGallery: [ArtHistoryImage]?
    
    static func getImageFromIndex(index: Int) -> UIImage{
        return UIImage(named: "\(index%5)")!
    }
}


struct ArtHistoryImage{
    
    var title = "Title"
    var subtitle = "Subtitle"
    
    var imageName: String?
    var image: UIImage?{
        guard let imageName = imageName else { return nil }
        return UIImage(named: imageName)
    }
}

