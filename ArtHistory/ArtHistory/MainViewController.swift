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
    private var transitionBubbleColor: UIColor?
    
    private var itemRows: [ [MainItemView] ] = []
    private var animator: UIDynamicAnimator!
    
    private var lastOffset: CGFloat = 0.0 //for calculate scrollView's delta offset
    
    private var selectedGameIndex = 0
    
    let gameItemView = UIView()
    let gameMenu1 = UIButton()
    let gameMenu2 = UIButton()
    let gameMenu3 = UIButton()
    
    @IBOutlet weak var topView: UIVisualEffectView!
    @IBOutlet weak var scrollView: UIScrollView!
    
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
        
        // game menu
        gameMenu1.setTitle("Lesson 1", forState: .Normal)
        gameMenu1.backgroundColor = UIColor.flatMagentaColor()
        gameMenu1.showsTouchWhenHighlighted = true
        gameMenu1.addTarget(self, action: "goToGame:", forControlEvents: .TouchUpInside)
        
        //
        scrollView.addSubview(gameItemView)
        [gameMenu1,gameMenu2,gameMenu3].forEach(scrollView.addSubview)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // setup items frame
        for (row,itemRow) in itemRows.enumerate(){
            for (col,item) in itemRow.enumerate(){
                
                let itemHeight = (scrollView.frame.height - topView.frame.height) / CGFloat(numberOfRows)
                
                let xOffset = itemWidth * CGFloat(col)
                let yOffset = itemHeight * CGFloat(row)
                
                item.center.x = xOffset + itemWidth / 2.0
                item.frame.origin.y = yOffset
                item.frame.size.height = itemHeight
            }
        }
        
        // setup UIKit Dynamic
        animator = UIDynamicAnimator(referenceView: scrollView)
        
        let springBehaviors = itemRows.flatMap{$0}.map{ item -> UIAttachmentBehavior in
            
            let springBehavior = UIAttachmentBehavior(item: item, attachedToAnchor: item.center)
            springBehavior.length = 5.0
            springBehavior.damping = 1.0
            springBehavior.frequency = 2.0
            
            //lock x coordinate
            let xCoordinate = item.frame.origin.x
            springBehavior.action = {
                item.frame.origin.x = xCoordinate
            }
            
            return springBehavior
        }
        
        springBehaviors.forEach(animator.addBehavior)
        
        // game items
        gameItemView.backgroundColor = UIColor.flatRedColor()
        
        gameItemView.frame.size = CGSize(width: 100, height: 100)
        gameItemView.layer.cornerRadius = gameItemView.frame.width / 2.0
        
        gameItemView.center.x = scrollView.frame.width / 2.0
        
        gameItemView.frame.origin.y = 1.5 * scrollView.frame.height - gameItemView.frame.height / 2.0 + scrollView.contentInset.top / 2.0 - 20.0
        
        
        
        // game menu 1
        let margin: CGFloat = 50
        
        gameMenu1.frame.size = CGSize(width: 85.0, height: 85.0)
        
        gameMenu1.layer.cornerRadius = gameMenu1.frame.width / 2.0
        gameMenu1.center.x = scrollView.frame.width / 2.0
        gameMenu1.frame.origin.y = gameItemView.frame.origin.y - ( gameMenu1.frame.height + margin )
        
        //
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollView.frame.height * 2 )
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showLesson"{
            let lessonVC = segue.destinationViewController as! LessonViewController
                
            lessonVC.transitioningDelegate = self
            lessonVC.modalPresentationStyle = .Custom
            
            lessonVC.colorTone = selectedItem.image?.getColors(CGSize(width: 25, height: 25))
            lessonVC.lesson = itemMap[selectedItem]!
        }
        
        if segue.identifier == "showGame"{
            let gameVC = segue.destinationViewController as! GameViewController
            gameVC.game = Game.randomGameFromLesson(selectedGameIndex)
            gameVC.transitioningDelegate = self
            gameVC.modalPresentationStyle = .Custom
        }
    }
    
    
    private func getImageFromIndex(index: Int) -> UIImage{
        return UIImage(named: "\(index%5)")!
    }
    
    
    private func setupItem(){
        view.layoutIfNeeded()
        
        // create items
        itemRows = (0..<numberOfRows).map{ _ -> [MainItemView] in
            
            let itemRow = (0..<numberOfItemsPerRow).map{ _ -> MainItemView in
                
                let itemFrame = CGRect(x: 0, y: 0, width: itemWidth, height: rowHeight)
                let item = MainItemView(frame: itemFrame)
                
                return item
            }
            
            return itemRow
        }
        
        // setup items properties
        itemRows.flatMap{$0}.enumerate().forEach{ index, item in
            
            item.image = artHistory.lessons[index].image
            item.text = artHistory.lessons[index].title
            
            item.action = { [weak self] in
                let localCenter = item.circleCenter
                if let _self = self{
                    _self.itemCenter = _self.view.convertPoint(localCenter, fromView: item)
                    _self.selectedItem = item
                    _self.transitionBubbleColor = _self.selectedItem.image?.getColors(CGSize(width: 25, height: 25)).backgroundColor
                    _self.performSegueWithIdentifier("showLesson", sender: nil)
                }
            }
            
            itemMap[item] = artHistory.lessons[index]
        }
        
        // add all items to scrollview
        itemRows.flatMap{$0}.forEach(scrollView.addSubview)
    }
    
    private func loadJSONData(){
        let dataPath = NSBundle.mainBundle().pathForResource("art_history_data", ofType: "json")!
        let data = NSData(contentsOfFile: dataPath)!
        
        let json = JSON(data: data)
        
        for (index,(_,lessonJSON)) in json["lessons"].enumerate(){
            
            var newLesson = Lesson()
            
            newLesson.title = lessonJSON["title"].string!
            newLesson.detail = lessonJSON["content"].string!
            newLesson.imageName = "lesson-\(index+1).png"
            
            newLesson.lessonGallery = [ArtHistoryImage]()
            
            for (_,(_,imageJSON)) in lessonJSON["images"].enumerate(){
                
                var artHistoryImage = ArtHistoryImage()
                artHistoryImage.title = imageJSON["title"].string!
                artHistoryImage.subtitle = imageJSON["subtitle"].string!
                artHistoryImage.imageName = imageJSON["name"].string!
                
                newLesson.lessonGallery! += [artHistoryImage]
            }
            artHistory.lessons += [newLesson]
        }
        
    }
    
    func goToGame(button: UIButton){
        let map: [UIButton:Int] = [gameMenu1:1, gameMenu2:2, gameMenu3:3]
        
        selectedGameIndex = map[button]!
        itemCenter = view.convertPoint(button.center, fromView: scrollView)
        transitionBubbleColor = button.backgroundColor
        performSegueWithIdentifier("showGame", sender: self)
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
            
            let item = spring.items.first!
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
        
        
        let unclampedT = ( scrollView.contentOffset.y + scrollView.contentInset.top ) / scrollView.frame.height
        let t = min(max(unclampedT,0),1)
        print(t)
    }
    
}

// MARK: UIViewControllerTransitioningDelegate
extension MainViewController: UIViewControllerTransitioningDelegate{
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Present
        transition.startingPoint = itemCenter
        transition.bubbleColor = transitionBubbleColor ?? UIColor.flatWhiteColor()
        return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Dismiss
        transition.startingPoint = itemCenter
        transition.bubbleColor = transitionBubbleColor ?? UIColor.flatWhiteColor()
        return transition
    }
}


