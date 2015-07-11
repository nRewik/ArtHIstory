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
        
        if self.text == nil{
            return
        }
        
        self.frame = rect
        
        var maxFontSize: CGFloat = 100.0
        let minFontSize: CGFloat = 5.0
        
        var q = Int(maxFontSize)
        var p = Int(minFontSize)
        
        let constraintSize = CGSize(width: rect.width, height: CGFloat.max)
        
        while(p <= q){
            let currentSize = (p + q) / 2
            self.font = self.font.fontWithSize( CGFloat(currentSize) )
            let text = NSAttributedString(string: self.text!, attributes: [NSFontAttributeName:self.font])
            let textRect = text.boundingRectWithSize(constraintSize, options: .UsesLineFragmentOrigin, context: nil)
            
            let labelSize = textRect.size
            
            if labelSize.height <= self.frame.height{
                p = currentSize + 1
            }else{
                q = currentSize - 1
            }
        }
    }
}

