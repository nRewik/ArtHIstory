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
  
  // Init
  var lesson: Lesson!
  var colorTone: UIImageColors!
  
  // States
  var topHeadViewOrigin: CGFloat?
  var topHeadHeightOrigin: CGFloat?
  var readOriginFrame: CGRect?
  var readImageViewOriginFrame: CGRect?
  var readIndexPath: NSIndexPath?
  
  /// Need update manually for performance reason
  var lessonContentHeight: CGFloat = 0.0
  
  var minimumTopViewHeight: CGFloat{
    return 70.0
  }
  var maximumTopViewHeight: CGFloat{
    return 150.0
  }
  
  @IBOutlet weak var topSpace_headViewConstraint: NSLayoutConstraint!
  @IBOutlet weak var heightConstraint_headView: NSLayoutConstraint!
  
  @IBOutlet weak var statusBarOverlayView: UIView!
  
  @IBOutlet weak var headView: UIView!
  @IBOutlet weak var headImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var backButton: UIButton!
  @IBOutlet weak var gradientView: UIView!
  
  @IBOutlet weak var closeButton: UIButton!
  
  @IBOutlet weak var statusBarDimView: UIView!
  @IBOutlet weak var dimView: UIView!
  @IBOutlet weak var readView: UIView!
  @IBOutlet weak var readViewTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var readViewBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var readviewLeadingConstraint: NSLayoutConstraint!
  @IBOutlet weak var readViewTralingConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var readImageView: UIImageView!
  @IBOutlet weak var readImageViewTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var readImageViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var readTextView: UITextView!
  
  @IBOutlet weak var tableView: UITableView!
  
  func setupInset(){
    tableView.contentInset = UIEdgeInsets(top: maximumTopViewHeight, left: 0, bottom: 0, right: 0)
  }
  func setupShadow(){
    headView.layer.shadowColor = UIColor.flatBlackColor().CGColor
    headView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    headView.layer.shadowOpacity = 0.3
    
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    setupInset()
    setupShadow()
    backButton.titleLabel?.font = UIFont.fontAwesomeOfSize(35.0)
    backButton.setTitle(String.fontAwesomeIconWithName(.ChevronCircleLeft), forState: .Normal)
    
    readView.layer.cornerRadius = 6.0
    
    headImageView.image = lesson.image
    titleLabel.text = lesson.title
    
    tableView.dataSource = self
    tableView.delegate = self
    
    setStatusBarStyle(UIStatusBarStyleContrast)
    
    view.layoutIfNeeded()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    let titleColor = UIColor(contrastingBlackOrWhiteColorOn: colorTone.backgroundColor, isFlat: true)
    let complementTitleColor = UIColor(complementaryFlatColorOf: titleColor)
    
    backButton.setTitleColor(titleColor, forState: .Normal)
    backButton.setTitleColor(complementTitleColor, forState: .Highlighted)
    backButton.setTitleColor(complementTitleColor, forState: .Selected)
    
    titleLabel.textColor = titleColor
    
    statusBarOverlayView.backgroundColor = colorTone.backgroundColor
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    // Update lessonContentHeight
    lessonContentHeight = {
      
      let titleAttributedString = NSAttributedString(string: lesson.detail, attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue-Thin", size: 18)!])
      let constraintedSize = CGSize(width: tableView.frame.width-30, height: 9999.0)
      let titleHeight = titleAttributedString.boundingRectWithSize(constraintedSize, options: .UsesLineFragmentOrigin, context: nil).height
      
      return 20 + titleHeight + 20
      }()
    
    updateGradientColor()
  }
  
  func updateGradientColor(){
    let gradientColor = colorTone.backgroundColor
    gradientView.backgroundColor = UIColor(gradientStyle: .TopToBottom, withFrame: gradientView.frame, andColors: [ gradientColor.colorWithAlphaComponent(0.0),gradientColor])
  }
  
  
  @IBAction func readCloseButtonDidTouch() {
    
    guard let readOriginFrame = readOriginFrame else { return }
    guard let readImageViewOriginFrame = readImageViewOriginFrame else { return }
    
    readViewTopConstraint.constant = readOriginFrame.origin.y
    readViewBottomConstraint.constant = view.bounds.height - (readOriginFrame.origin.y + readOriginFrame.height)
    readviewLeadingConstraint.constant = readOriginFrame.origin.x
    readViewTralingConstraint.constant = view.bounds.width - (readOriginFrame.origin.x + readOriginFrame.width)
    
    readImageViewTopConstraint.constant = readImageViewOriginFrame.origin.y
    readImageViewHeightConstraint.constant = readImageViewOriginFrame.height
    
    if let topHeadViewOrigin = topHeadViewOrigin{
      topSpace_headViewConstraint.constant = topHeadViewOrigin
    }
    if let topHeadHeightOrigin = topHeadHeightOrigin{
      heightConstraint_headView.constant = topHeadHeightOrigin
    }
    
    setStatusBarStyle(UIStatusBarStyleContrast)
    
    UIView.animateWithDuration(0.5,
    animations: {
      self.dimView.alpha = 0.0
      self.statusBarDimView.alpha = 0.0
      self.readView.alpha = 1.0
      self.closeButton.alpha = 0.0
      self.view.layoutIfNeeded()
    },
    completion: { finish in
      if let readIndexPath = self.readIndexPath{
        let cell = self.tableView.cellForRowAtIndexPath(readIndexPath)!
        cell.hidden = false
      }
      
      self.readView.alpha = 0.0
      self.readOriginFrame = nil
      self.readImageViewOriginFrame = nil
      self.readIndexPath = nil
      self.topHeadViewOrigin = nil
      self.topHeadHeightOrigin = nil
    })
  }
  
  @IBAction func unwindToLessonView(segue: UIStoryboardSegue){
    
  }
  
}

extension LessonViewController: UITableViewDataSource{
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    switch(section){
    case 0:
      return 1
    case 1:
      return lesson.lessonGallery.count
    default:
      return 0
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    if indexPath.section == 0{
      let contentCell = tableView.dequeueReusableCellWithIdentifier("LessonContentTableViewCell") as! LessonContentTableViewCell
      contentCell.contentText = lesson.detail
      return contentCell
    }
    
    if indexPath.section == 1{
      if let thumbnailImageCell = tableView.dequeueReusableCellWithIdentifier("ThumbnailImageTableViewCell") as? ThumbnailImageTableViewCell
      {
        thumbnailImageCell.thumbnailImage = lesson.lessonGallery[indexPath.row].image
        thumbnailImageCell.title = lesson.lessonGallery[indexPath.row].title
        thumbnailImageCell.subtitle = lesson.lessonGallery[indexPath.row].subtitle
        
        return thumbnailImageCell
      }
    }
    
    assertionFailure("should return all possible UITableViewCells")
    return UITableViewCell()
  }
  
}

//MARK: TableView Delegate
extension LessonViewController: UITableViewDelegate{
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: false)
    if indexPath.section == 1{
      readImageView.image = lesson.lessonGallery[indexPath.row].image
      readTextView.text = lesson.lessonGallery[indexPath.row].subtitle
      
      let cell = tableView.cellForRowAtIndexPath(indexPath) as! ThumbnailImageTableViewCell
      let convertedRect = cell.convertRect(cell.bounds, toView: view)
      let imageViewConvertedRect = cell.thumbnailImageView.convertRect(cell.thumbnailImageView.bounds, toView: cell)
      
      readOriginFrame = convertedRect
      readImageViewOriginFrame = imageViewConvertedRect
      readIndexPath = indexPath
      
      cell.hidden = true
      
      readViewTopConstraint.constant = convertedRect.origin.y
      readViewBottomConstraint.constant = view.bounds.height - (convertedRect.origin.y + convertedRect.height)
      readviewLeadingConstraint.constant = convertedRect.origin.x
      readViewTralingConstraint.constant = view.bounds.width - (convertedRect.origin.x + convertedRect.width)
      
      readImageViewTopConstraint.constant = imageViewConvertedRect.origin.y
      readImageViewHeightConstraint.constant = imageViewConvertedRect.height
      
      view.layoutIfNeeded()
      
      [readViewBottomConstraint,readviewLeadingConstraint,readViewTralingConstraint].forEach{ $0.constant = 15.0 }
      readViewTopConstraint.constant = 30.0
      readImageViewTopConstraint.constant = 50.0
      readImageViewHeightConstraint.constant = 175.0
      
      topHeadViewOrigin = topSpace_headViewConstraint.constant
      topSpace_headViewConstraint.constant = -minimumTopViewHeight
      
      topHeadHeightOrigin = heightConstraint_headView.constant
      heightConstraint_headView.constant = minimumTopViewHeight
      
      readView.alpha = 1.0
      closeButton.alpha = 1.0
      setStatusBarStyle(.LightContent)
      UIView.animateWithDuration(0.5,
      animations: {
        self.view.layoutIfNeeded()
        self.dimView.alpha = 0.9
        self.statusBarDimView.alpha = 0.9
        self.readView.alpha = 1.0
        self.readTextView.contentOffset = CGPoint.zero
      },
      completion: {finish in
        self.readTextView.contentOffset = CGPoint.zero
      })
    }
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if indexPath.section == 1{
      let thumbnailImageCellHeight = heightForThumbnailImageCellForRow(indexPath.row)
      return thumbnailImageCellHeight
    }
    return lessonContentHeight
  }
  
  func scrollViewDidScroll(scrollView: UIScrollView) {
    
    if scrollView != tableView{
      return
    }
    
    //println(scrollView.contentOffset.y)
    let currentYOffset = scrollView.contentOffset.y + tableView.contentInset.top
    let topViewHeight = maximumTopViewHeight - currentYOffset
    let newHeight = max( minimumTopViewHeight , topViewHeight)
    
    heightConstraint_headView.constant = newHeight
    //println("\(newHeight)")
    
    
    //hide topbar when scroll far than lesson content
    let beginYoffsetThumbnailZone = lessonContentHeight - minimumTopViewHeight
    if scrollView.contentOffset.y > beginYoffsetThumbnailZone{
      let delta = scrollView.contentOffset.y - beginYoffsetThumbnailZone
      topSpace_headViewConstraint.constant = max(-minimumTopViewHeight,-delta)
    }else{
      topSpace_headViewConstraint.constant = 0
    }
  }
  
  func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
    guard scrollView === tableView else { return true }
    return readIndexPath === nil
  }
  
}
