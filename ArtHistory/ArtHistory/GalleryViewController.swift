//
//  GalleryViewController.swift
//  ArtHistory
//
//  Created by Nutchaphon Rewik on 7/12/15.
//  Copyright (c) 2015 Nutchaphon Rewik. All rights reserved.
//

import UIKit
import FontAwesome_swift
import ChameleonFramework

class GalleryViewController: UIViewController {

    var imageViews: [UIImageView] = []
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var closeButton: UIButton!

    @IBOutlet weak var leadingConstraint_circle: NSLayoutConstraint!
    @IBOutlet weak var circleIndicator: UIView!
    @IBOutlet weak var barIndicator: UIView!
    
    var currentPage: Int {
        return Int( scrollView.contentOffset.x / scrollView.frame.width )
    }
    var totalPage: Int{
        return imageViews.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let numberOfItems = 10
        for i in 0..<numberOfItems{
            let imageView = UIImageView(image: Lesson.getImageFromIndex(i))
            imageView.contentMode = .ScaleAspectFill
            imageView.clipsToBounds = true
            scrollView.addSubview(imageView)
            imageViews += [imageView]
        }
        scrollView.delegate = self
        
        closeButton.titleLabel?.font = UIFont.fontAwesomeOfSize(35.0)
        closeButton.titleLabel?.textColor = UIColor.flatWhiteColor()
        closeButton.setTitle( String.fontAwesomeIconWithName(.Close), forState: .Normal)
        closeButton.layer.cornerRadius = closeButton.frame.width / 2.0
        closeButton.layer.borderColor = UIColor.flatBlueColor().CGColor
        closeButton.layer.borderWidth = 2.0
        
        circleIndicator.layer.cornerRadius = circleIndicator.frame.width / 2.0
        circleIndicator.layer.borderColor = UIColor.flatBlueColor().CGColor
        circleIndicator.layer.borderWidth = 2.0

        
        barIndicator.backgroundColor = UIColor.flatWhiteColor()
        
        flatify()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
        let width = scrollView.frame.width
        let height = scrollView.frame.height
        for i in 0..<imageViews.count{
            let xOffset = CGFloat(i) * width
            let imageFrame = CGRect(x: xOffset, y: 0.0, width: width, height: height)
            let imageView = imageViews[i]
            imageView.frame = imageFrame
        }
        scrollView.contentSize = CGSize(width: CGFloat(imageViews.count) * width, height: height)
        scrollView.contentOffset = CGPointZero;
    }
    
    func updateIndicator(){
        let totalWidth = barIndicator.frame.width
        let percentage = CGFloat(currentPage) / CGFloat(totalPage-1)
        leadingConstraint_circle.constant = -1.0 * (totalWidth * percentage)
        UIView.animateWithDuration(0.3){
            self.view.layoutIfNeeded()
        }
    }
}

extension GalleryViewController: UIScrollViewDelegate{
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let totalWidth = barIndicator.frame.width
        let percentage = scrollView.contentOffset.x / (scrollView.contentSize.width - scrollView.frame.width)
        leadingConstraint_circle.constant = -1.0 * (totalWidth * percentage)
        UIView.animateWithDuration(0.3){
            self.view.layoutIfNeeded()
        }
    }
    
}






