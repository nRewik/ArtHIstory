//
//  MainViewController+DynamicItem.swift
//  ArtHistory
//
//  Created by Nutchaphon Rewik on 30/12/2015.
//  Copyright © 2015 Nutchaphon Rewik. All rights reserved.
//

import UIKit

extension MainViewController{
    
    var itemWidth: CGFloat{
        return scrollView.frame.width / CGFloat(numberOfItemsPerRow)
    }
    
    var numberOfItemsPerRow: Int{
        return 3
    }
    
    var numberOfRows: Int{
        return 3
    }
    
    var rowHeight: CGFloat{
        return 150.0
    }
    
    
}