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
  
  private var lessons: [Lesson] = []
  private var itemMap: [MainItemView:Lesson] = [:]
  
  private let transition = BubbleTransition()
  
  private var itemCenter: CGPoint!
  private var selectedItem: MainItemView!
  private var transitionBubbleColor: UIColor?
  
  private var itemRows: [ [MainItemView] ] = []
  private var animator: UIDynamicAnimator!
  
  private var lastOffset: CGFloat = 0.0 //for calculate scrollView's delta offset
  
  private var selectedGameIndex = 0
  
  var gameMenuAnimationTimer: NSTimer!
  
  private let gameTitleLabel = UILabel()
  
  private let gameMenu1 = UIButton()
  private let gameMenu2 = UIButton()
  private let gameMenu3 = UIButton()
  
  private let gameMenu1Label = UILabel()
  private let gameMenu2Label = UILabel()
  private let gameMenu3Label = UILabel()
  
  @IBOutlet weak var topView: UIVisualEffectView!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var moreView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    lessons = Lesson.getAllLessons()
    
    setupItem()
    let topInset = topView.frame.height + 20.0
    scrollView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
    scrollView.setContentOffset( CGPoint(x: 0.0, y: -scrollView.contentInset.top), animated: false)
    lastOffset = scrollView.contentOffset.y
    scrollView.delegate = self
    
    // game menu
    gameMenu1.setTitle("1", forState: .Normal)
    gameMenu1.backgroundColor = UIColor.flatMagentaColor()
    
    gameMenu2.setTitle("2", forState: .Normal)
    gameMenu2.backgroundColor = UIColor.flatWatermelonColor()
    
    gameMenu3.setTitle("3", forState: .Normal)
    gameMenu3.backgroundColor = UIColor.flatTealColor()
    
    [gameMenu1,gameMenu2,gameMenu3].forEach{
      $0.showsTouchWhenHighlighted = true
      $0.layer.borderWidth = 2.0
      $0.layer.borderColor = $0.backgroundColor!.lightenByPercentage(0.25).CGColor
      $0.addTarget(self, action: "goToGame:", forControlEvents: .TouchUpInside)
    }
    
    gameTitleLabel.text = "Quiz"
    gameMenu1Label.text = "Egypt Art, Greek Art, Roman Art"
    gameMenu2Label.text = "Early Christian - Gothic"
    gameMenu3Label.text = "Renaissance"
    
    //
    moreView.translatesAutoresizingMaskIntoConstraints = false
    
    //
    [gameMenu1,gameMenu2,gameMenu3].forEach(scrollView.addSubview)
    [gameMenu1Label, gameMenu2Label, gameMenu3Label].forEach(scrollView.addSubview)
    scrollView.addSubview(gameTitleLabel)
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    gameMenuAnimationTimer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "animateGameMeunButton", userInfo: nil, repeats: true)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    // setup items frame
    for (row,itemRow) in itemRows.enumerate(){
      for (col,item) in itemRow.enumerate(){
        
        let itemHeight = (scrollView.frame.height - topView.frame.height - moreView.frame.height) / CGFloat(numberOfRows)
        
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
    
    // Game menu
    let centerY = 1.5 * scrollView.frame.height + scrollView.contentInset.top / 2.0 - 20.0 + 15
    let margin: CGFloat = 20
    [gameMenu1,gameMenu2,gameMenu3].forEach{
      $0.frame.size = CGSize(width: 50.0, height: 50.0)
      $0.titleLabel?.font = $0.titleLabel?.font.fontWithSize(17)
      $0.layer.cornerRadius = $0.frame.width / 2.0
    }
    
    // Game menu 2
    gameMenu2.frame.origin.x = 25
    gameMenu2.frame.origin.y = centerY - gameMenu2.frame.height / 2
    
    // Game menu 1
    gameMenu1.frame.origin.x = 25
    gameMenu1.frame.origin.y = gameMenu2.frame.origin.y - gameMenu1.frame.height - margin
    
    // Game menu 3
    gameMenu3.frame.origin.x = 25
    gameMenu3.frame.origin.y = gameMenu2.frame.origin.y + gameMenu3.frame.height + margin
    
    // Game menu label
    let gameMenuLabelMap = [gameMenu1Label:gameMenu1, gameMenu2Label: gameMenu2, gameMenu3Label: gameMenu3]
    [gameMenu1Label, gameMenu2Label, gameMenu3Label].forEach{
      $0.font = $0.font.fontWithSize(13)
      $0.sizeToFit()
      $0.center.y = gameMenuLabelMap[$0]!.center.y
      $0.frame.origin.x = gameMenuLabelMap[$0]!.frame.origin.x + gameMenu1.bounds.width + 15
    }
    
    // Game menu title
    gameTitleLabel.font = gameTitleLabel.font.fontWithSize(50)
    gameTitleLabel.sizeToFit()
    gameTitleLabel.frame.origin.y = gameMenu1.frame.origin.y - 25 - gameTitleLabel.bounds.height
    gameTitleLabel.frame.origin.x = gameMenu1.frame.origin.x + 5
    
    //
    moreView.frame.size = CGSize(width: view.frame.width, height: 20.0)
    
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
      
      item.image = lessons[index].image
      item.text = lessons[index].title
      
      item.action = { [weak self] in
        let localCenter = item.circleCenter
        if let _self = self{
          _self.itemCenter = _self.view.convertPoint(localCenter, fromView: item)
          _self.selectedItem = item
          _self.transitionBubbleColor = _self.selectedItem.image?.getColors(CGSize(width: 25, height: 25)).backgroundColor
          _self.performSegueWithIdentifier("showLesson", sender: nil)
        }
      }
      
      itemMap[item] = lessons[index]
    }
    
    // add all items to scrollview
    itemRows.flatMap{$0}.forEach(scrollView.addSubview)
  }
  
  func goToGame(button: UIButton){
    let map: [UIButton:Int] = [gameMenu1:1, gameMenu2:2, gameMenu3:3]
    
    selectedGameIndex = map[button]!
    itemCenter = view.convertPoint(button.center, fromView: scrollView)
    transitionBubbleColor = button.backgroundColor
    performSegueWithIdentifier("showGame", sender: self)
  }
  
  func animateGameMeunButton(){
    
    var gameMenus = [gameMenu1, gameMenu2, gameMenu3]
    gameMenus.shuffleInPlace()
    
    let gameMenuToAnimate = gameMenus.first!
    UIView.animateWithDuration(0.8, delay: 0.0, usingSpringWithDamping: 0.35, initialSpringVelocity: 0.2,
    options: [.Autoreverse,.AllowUserInteraction,.BeginFromCurrentState],
    animations: {
      gameMenuToAnimate.transform = CGAffineTransformMakeScale(1.15, 1.15)
    }, completion: { finish in
      gameMenuToAnimate.transform = CGAffineTransformIdentity
    })
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
    // print(t)
    
    moreView.alpha = (1-t) * 1 + t * 0
    
    let moreViewBaseYoffset = view.frame.height - moreView.frame.height
    let moreViewYoffset = (1-t) * 0 + t * -moreView.frame.height
    moreView.frame.origin.y = moreViewBaseYoffset - moreViewYoffset
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


