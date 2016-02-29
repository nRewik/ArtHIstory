//
//  Lesson.swift
//  ArtHistory
//
//  Created by Nutchaphon Rewik on 7/12/15.
//  Copyright (c) 2015 Nutchaphon Rewik. All rights reserved.
//

import UIKit
import SwiftyJSON

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
  
  var lessonGallery: [ArtHistoryImage] = []
  
  static func getImageFromIndex(index: Int) -> UIImage{
    return UIImage(named: "\(index%5)")!
  }
  
  static func getAllLessons() -> [Lesson]{
    let dataPath = NSBundle.mainBundle().pathForResource("art_history_data", ofType: "json")!
    let data = NSData(contentsOfFile: dataPath)!
    let json = JSON(data: data)
    
    let lessons = json["lessons"].enumerate().map{ index, json -> Lesson in
      
      let (_,lessonJSON) = json
      
      var newLesson = Lesson()
      newLesson.title = lessonJSON["title"].string!
      newLesson.detail = lessonJSON["content"].string!
      newLesson.imageName = "lesson-\(index+1).png"
      
      newLesson.lessonGallery = lessonJSON["images"].map{ _, imageJSON -> ArtHistoryImage in
        var artHistoryImage = ArtHistoryImage()
        artHistoryImage.title = imageJSON["title"].string!
        
        if imageJSON["subtitle"].stringValue.lowercaseString.containsString("null"){
          artHistoryImage.subtitle = ""
        }else{
          artHistoryImage.subtitle = imageJSON["subtitle"].stringValue
        }
        
        artHistoryImage.imageName = imageJSON["name"].string!
        return artHistoryImage
      }
      return newLesson
    }
    
    return lessons
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

