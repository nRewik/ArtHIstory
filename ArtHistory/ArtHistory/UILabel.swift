//
//  UILabel.swift
//  ArtHistory
//
//  Created by Nutchaphon Rewik on 7/11/15.
//  Copyright (c) 2015 Nutchaphon Rewik. All rights reserved.
//

import UIKit

extension UILabel{
    
    func adjustFontSizeToFitRect(rect : CGRect){
        
        if text == nil{
            return
        }
        
        let maxFontSize: CGFloat = 100.0
        let minFontSize: CGFloat = 5.0
        
        var q = Int(maxFontSize)
        var p = Int(minFontSize)
        
        let constraintSize = CGSize(width: rect.width, height: CGFloat.max)
        
        let tmpLabel = UILabel(frame: rect)
        tmpLabel.font = font
        
        while(p < q){
            let currentSize = (p + q) / 2
            tmpLabel.font = tmpLabel.font.fontWithSize( CGFloat(currentSize) )
            let text = NSAttributedString(string: self.text!, attributes: [NSFontAttributeName:tmpLabel.font])
            let textRect = text.boundingRectWithSize(constraintSize, options: .UsesLineFragmentOrigin, context: nil)
            
            let labelSize = textRect.size
            
            if  labelSize.height < tmpLabel.frame.height &&
                labelSize.height >= tmpLabel.frame.height-10 &&
                labelSize.width < tmpLabel.frame.width &&
                labelSize.width >= tmpLabel.frame.width-10
            {
                print("in break")
                break
            }else if labelSize.height > tmpLabel.frame.height || labelSize.width > tmpLabel.frame.width{
                q = currentSize - 1
            }else{
                p = currentSize + 1
            }
        }

        font = tmpLabel.font
    }
}

