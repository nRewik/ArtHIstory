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
import BubbleTransition

class LessonViewController: UIViewController {

    
    var colorTone: UIImageColors!
    let transition = BubbleTransition()
    
    
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
        
        collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: playGalleryView.frame.width+10)
        collectionView.dataSource = self
        collectionView.delegate = self
        //setup flowLayout.itemSize
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let length = collectionView.frame.height - 10.0
        flowLayout.itemSize = CGSize(width: length, height: length)
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showGallery"{
            if let lessonVC = segue.destinationViewController as? GalleryViewController {
                
                lessonVC.transitioningDelegate = self
                lessonVC.modalPresentationStyle = .Custom
                
//                lessonVC.colorTone = selectedItem.image?.getColors()
            }
        }
    }
    
    @IBAction func unwindToLessonView(segue: UIStoryboardSegue){
        
    }

}

extension LessonViewController: UICollectionViewDataSource{
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ThumbnailCollectionViewCell", forIndexPath: indexPath) as! ThumbnailCollectionViewCell
        cell.image = Lesson.getImageFromIndex(indexPath.row)
        cell.action = {
            let actualIndexPath = collectionView.indexPathForCell(cell)!
            println(actualIndexPath)
        }
        return cell
    }
}
extension LessonViewController: UICollectionViewDelegate{
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("select \(indexPath.row)")
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
        if scrollView != textView{
            return
        }
        
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

// MARK: UIViewControllerTransitioningDelegate
extension LessonViewController: UIViewControllerTransitioningDelegate{
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Present
        transition.startingPoint = view.convertPoint(playGalleryButton.center, fromView: playGalleryView)
        transition.bubbleColor = colorTone.backgroundColor
        return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Dismiss
        transition.startingPoint = view.convertPoint(playGalleryButton.center, fromView: playGalleryView)
        transition.bubbleColor = colorTone.backgroundColor
        return transition
    }
}
