//
//  LessonViewController.swift
//  ArtHistory
//
//  Created by Nutchaphon Rewik on 7/11/15.
//  Copyright (c) 2015 Nutchaphon Rewik. All rights reserved.
//

import UIKit
import FontAwesome_swift
import ChameleonFramework

class LessonViewController: UIViewController {

    
    var colorTone: UIImageColors!
    
    @IBOutlet weak var heightConstraint_topBlurView: NSLayoutConstraint!
    
    @IBOutlet weak var behindTopBlurView: UIView!
    @IBOutlet weak var topBlurView: UIVisualEffectView!
    @IBOutlet weak var topViewContent: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var bottomBlurView: UIVisualEffectView!
    @IBOutlet weak var bottomViewContent: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var playGalleryView: UIView!
    @IBOutlet weak var playGalleryButton: UIButton!
    
    @IBOutlet weak var textView: UITextView!
    
    func setupInset(){
        let topInset = topBlurView.frame.height
        let bottomInset = bottomBlurView.frame.height
        let margin: CGFloat = 20.0
        let sideInset: CGFloat = 15.0
        textView.textContainerInset = UIEdgeInsets(top: topInset+margin, left: sideInset, bottom: bottomInset+margin, right: sideInset)
        textView.setContentOffset(CGPoint(x: 0, y: -textView.contentInset.top), animated: false)
    }
    func setupShadow(){
        topBlurView.layer.shadowColor = UIColor.flatBlackColor().CGColor
        topBlurView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        topBlurView.layer.shadowOpacity = 0.3
        
        bottomBlurView.layer.shadowColor = UIColor.flatBlackColor().CGColor
        bottomBlurView.layer.shadowOffset = CGSize(width: 0.0, height: -1.0)
        bottomBlurView.layer.shadowOpacity = 0.3
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.layoutIfNeeded()
        setupInset()
        setupShadow()
        backButton.titleLabel?.font = UIFont.fontAwesomeOfSize(30.0)
        backButton.setTitle(String.fontAwesomeIconWithName(.ChevronCircleLeft), forState: .Normal)
        
        playGalleryButton.titleLabel?.font = UIFont.fontAwesomeOfSize(40.0)
        playGalleryButton.setTitle( String.fontAwesomeIconWithName(.Play), forState: .Normal)
        
        textView.delegate = self
        
        adjustTitleLabelFontSize()
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return ChameleonStatusBar.statusBarStyleForColor(colorTone.backgroundColor)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        backButton.setTitleColor(colorTone.backgroundColor, forState: .Normal)
        titleLabel.textColor = colorTone.backgroundColor
        
        playGalleryView.backgroundColor = colorTone.backgroundColor
        let playButtonColor = UIColor(contrastingBlackOrWhiteColorOn: colorTone.backgroundColor, isFlat: true)
        playGalleryButton.setTitleColor( playButtonColor, forState: .Normal)
        
        let gradientColor = UIColor(gradientStyle: .TopToBottom, withFrame: behindTopBlurView.frame, andColors: [colorTone.backgroundColor,UIColor.flatWhiteColor()])
        behindTopBlurView.backgroundColor = gradientColor
        
        flatifyAndContrast()
    }

}

extension LessonViewController: UITextViewDelegate{
    
    var minimumTopViewHeight: CGFloat{
        return 60.0
    }
    var maximumTopViewHeight: CGFloat{
        return 150.0
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let currentYOffset = scrollView.contentOffset.y
        let topViewHeight = maximumTopViewHeight - currentYOffset
        let newHeight = max( minimumTopViewHeight , topViewHeight)
        
        heightConstraint_topBlurView.constant = newHeight
        
        if newHeight < maximumTopViewHeight{
            adjustTitleLabelFontSize()
        }
 
        view.layoutIfNeeded()
    }
    func adjustTitleLabelFontSize(){
        var titleRect = titleLabel.frame
        titleRect.size.height = topBlurView.frame.height - 30
        titleLabel.adjustFontSizeToFitRect(titleRect)
    }
    
}
