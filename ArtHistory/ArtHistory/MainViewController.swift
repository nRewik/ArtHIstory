//
//  MainViewController.swift
//  ArtHistory
//
//  Created by Nutchaphon Rewik on 7/11/15.
//  Copyright (c) 2015 Nutchaphon Rewik. All rights reserved.
//

import UIKit
import BubbleTransition
import ChameleonFramework
import SwiftyJSON

class MainViewController: UIViewController {

    
    private var artHistory = ArtHistory()
    private var itemMap: [MainItemView:Lesson] = [:]
    
    private let transition = BubbleTransition()
    
    private var itemCenter: CGPoint!
    private var selectedItem: MainItemView!
    
    private var itemRows: [ [MainItemView] ] = []
    private var animator: UIDynamicAnimator!
    
    private var lastOffset: CGFloat = 0.0 //for calculate scrollView's delta offset
    
    @IBOutlet weak private var topView: UIVisualEffectView!
    @IBOutlet weak private var scrollView: UIScrollView!
    
    private func getImageFromIndex(index: Int) -> UIImage{
        return UIImage(named: "\(index%5)")!
    }
    private func setupItem(){
        view.layoutIfNeeded()
        
        let scrollViewHeight = scrollView.frame.height
        let scrollViewWidth = scrollView.frame.width
        
        let numberOfRows = 5
        let numberOfItemsPerRow = 3
        
        let itemWidth = scrollViewWidth / CGFloat(numberOfItemsPerRow)
        let rowHeight: CGFloat = 135.0
        
        // setup item in scrollView
        itemRows = []
        var count = 0
        for row in 0..<numberOfRows{
            var itemRow = [MainItemView]()
            for col in 0..<numberOfItemsPerRow{
                let xOffset = itemWidth * CGFloat(col)
                let yOffset = rowHeight * CGFloat(row)
                let itemFrame = CGRect(x: xOffset, y: yOffset, width: itemWidth, height: rowHeight)
                let item = MainItemView(frame: itemFrame)
                item.image = artHistory.lessons[count].image
                item.text = artHistory.lessons[count].title
                item.action = {
                    let localCenter = item.circleCenter
                    self.itemCenter = self.view.convertPoint(localCenter, fromView: item)
                    self.selectedItem = item
                    self.performSegueWithIdentifier("showLesson", sender: nil)
                }
                itemRow += [item]
                itemMap[item] = artHistory.lessons[count]
                scrollView.addSubview(item)
                
                count++
            }
            itemRows += [ itemRow ]
        }
        scrollView.contentSize = CGSize(width: scrollViewWidth, height: rowHeight*5)
        
        // setup UIKit Dynamic
        animator = UIDynamicAnimator(referenceView: scrollView)
        for row in 0..<numberOfRows{
            let currentRow = itemRows[row]
            for col in 0..<numberOfItemsPerRow{
                let item = currentRow[col]
                let springBehavior = UIAttachmentBehavior(item: item, attachedToAnchor: item.center)
                springBehavior.length = 5.0
                springBehavior.damping = 1.0
                springBehavior.frequency = 2.0
                
                //lock x coordinate
                let xCoordinate = item.frame.origin.x
                springBehavior.action = {
                    item.frame.origin.x = xCoordinate
                }
                ////
                animator.addBehavior(springBehavior)
            }
        }
        
    }
    
    private func loadJSONData(){
        let dataPath = NSBundle.mainBundle().pathForResource("art_history_data", ofType: "json")!
        let data = NSData(contentsOfFile: dataPath)!
        
        let json = JSON(data: data)
        
        for (index,(_,lessonJSON)) in enumerate(json["lessons"]){
            
            var newLesson = Lesson()
            
            newLesson.title = lessonJSON["title"].string!
            newLesson.detail = lessonJSON["content"].string!
            newLesson.image = UIImage(named: "lesson-\(index+1).png")!
            
            newLesson.lessonGallery = [ArtHistoryImage]()
            for (index,(_,imageJSON)) in enumerate(lessonJSON["images"]){
                
                var artHistoryImage = ArtHistoryImage()
                artHistoryImage.title = imageJSON["title"].string!
                artHistoryImage.subtitle = imageJSON["subtitle"].string!
                artHistoryImage.image = UIImage(named: imageJSON["name"].string!)!
                
                newLesson.lessonGallery! += [artHistoryImage]
            }
            artHistory.lessons += [newLesson]
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadJSONData()
        
        setupItem()
        let topInset = topView.frame.height + 20.0
        scrollView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        scrollView.setContentOffset( CGPoint(x: 0.0, y: -scrollView.contentInset.top), animated: false)
        lastOffset = scrollView.contentOffset.y
        scrollView.delegate = self
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showLesson"{
            if let lessonVC = segue.destinationViewController as? LessonViewController {
                
                lessonVC.transitioningDelegate = self
                lessonVC.modalPresentationStyle = .Custom
                
                lessonVC.colorTone = selectedItem.image?.getColors(CGSize(width: 25, height: 25))
                lessonVC.lesson = itemMap[selectedItem]!
            }
        }

    }
    
    //MARK: Unwind Segue
    @IBAction func unwindToMainMenu(segue:UIStoryboardSegue){

    }
}
// MARK: UIScrollViewDelegate
extension MainViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(scrollView: UIScrollView) {

        //update UIKit Dynamic
        let delta = scrollView.contentOffset.y - lastOffset
        for behavior in animator.behaviors{
            let spring = behavior as! UIAttachmentBehavior
            let yDistance = scrollView.contentOffset.y - spring.anchorPoint.y
            let scrollResistance = yDistance / 1500.0
            
            let item = spring.items.first as! UIDynamicItem
            var center = item.center
            center.y += delta
            if (delta < 0) {
                center.y += max(delta, delta*scrollResistance);
            }else {
                center.y += min(delta, delta*scrollResistance);
            }
            item.center = center
            animator.updateItemUsingCurrentState(item)
        }
        lastOffset = scrollView.contentOffset.y
    }
    
}
// MARK: UIViewControllerTransitioningDelegate
extension MainViewController: UIViewControllerTransitioningDelegate{
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Present
        transition.startingPoint = itemCenter
        transition.bubbleColor = selectedItem.image?.getColors(CGSize(width: 25, height: 25)).backgroundColor ?? UIColor.flatWhiteColor()
        return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Dismiss
        transition.startingPoint = itemCenter
        transition.bubbleColor = selectedItem.image?.getColors(CGSize(width: 25, height: 25)).backgroundColor ?? UIColor.flatWhiteColor()
        return transition
    }
}


