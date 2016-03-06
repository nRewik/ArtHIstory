//
//  LessonViewController+CellHeight.swift
//  Art History
//
//  Created by Nutchaphon Rewik on 29/02/2016.
//  Copyright © 2016 Nutchaphon Rewik. All rights reserved.
//

import UIKit

extension LessonViewController{
  
  func thumbnailImageTitleHeightForRow(row: Int) -> CGFloat{
    let artHistoryImage = lesson.lessonGallery[row]
    let titleAttributedString = NSAttributedString(string: artHistoryImage.title, attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue-Medium", size: 22)!])
    let constraintedSize = CGSize(width: tableView.frame.width-20, height: 9999.0)
    let titleHeight = titleAttributedString.boundingRectWithSize(constraintedSize, options: .UsesLineFragmentOrigin, context: nil).height
    
    return titleHeight
  }
  
  func thumbnailImageSubtitleHeightForRow(row: Int) -> CGFloat{
    let artHistoryImage = lesson.lessonGallery[row]
    let titleAttributedString = NSAttributedString(string: artHistoryImage.subtitle, attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue-Light", size: 17)!])
    let constraintedSize = CGSize(width: tableView.frame.width-30, height: 9999.0)
    let titleHeight = titleAttributedString.boundingRectWithSize(constraintedSize, options: .UsesLineFragmentOrigin, context: nil).height
    
    return min(titleHeight,105)
  }
  
  func thumbnailImageHeightForRow(row: Int) -> CGFloat{
    if lesson.lessonGallery[row].image == nil{
      return 0
    }

    let image = lesson.lessonGallery[row].image!
    
    // guard divide by zero
    if image.size.height - 0.0 < 0.001{
      return 0
    }
    
    let ratio = image.size.width / image.size.height
    return tableView.frame.width / ratio
  }
  
  
  func heightForThumbnailImageCellForRow(row :Int) -> CGFloat{
    let titleHeight = thumbnailImageTitleHeightForRow(row)
    let imageHeight = thumbnailImageHeightForRow(row)
    let subtitleHeight = thumbnailImageSubtitleHeightForRow(row)
    
    let totalHeight = 10 + titleHeight + 10 + imageHeight + 10 + subtitleHeight + 10 + 15
    
    return totalHeight
  }
  
}