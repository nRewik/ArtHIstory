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
    
    var lesson: Lesson!
    
    var colorTone: UIImageColors!

    var lessonContentHeight: CGFloat{
        
        let titleAttributedString = NSAttributedString(string: lesson.detail, attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue-Thin", size: 18)!])
        
        
        let constraintedSize = CGSize(width: tableView.frame.width-30, height: 9999.0)
        
        let titleHeight = titleAttributedString.boundingRectWithSize(constraintedSize, options: .UsesLineFragmentOrigin, context: nil).height
        
        return 20 + titleHeight + 20
    }
    
    var minimumTopViewHeight: CGFloat{
        return 67.5
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
        
        headImageView.image = lesson.image
        titleLabel.text = lesson.title
        
        tableView.dataSource = self
        tableView.delegate = self
        
        adjustTitleLabelFontSize()
        view.layoutIfNeeded()
        
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return ChameleonStatusBar.statusBarStyleForColor(colorTone.backgroundColor)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        backButton.setTitleColor(UIColor.flatBlackColor(), forState: .Normal)
        backButton.setTitleColor(UIColor.flatWhiteColor(), forState: .Highlighted)
        backButton.setTitleColor(UIColor.flatWhiteColor(), forState: .Selected)

        titleLabel.textColor = UIColor.flatBlackColor()
        
        statusBarOverlayView.backgroundColor = colorTone.backgroundColor

        flatifyAndContrast()
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
            return lesson.lessonGallery?.count ?? 0
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
            
            if let thumbnailImageCell = tableView.dequeueReusableCellWithIdentifier("ThumbnailImageTableViewCell") as? ThumbnailImageTableViewCell, lessonGallery = lesson.lessonGallery{
                
                thumbnailImageCell.thumbnailImage = lessonGallery[indexPath.row].image
                thumbnailImageCell.title = lessonGallery[indexPath.row].title
                thumbnailImageCell.subtitle = lessonGallery[indexPath.row].subtitle
                
                return thumbnailImageCell
            }
        }
        return UITableViewCell()
    }
    
}

//MARK: TableView Delegate
extension LessonViewController: UITableViewDelegate{
    
    //MARK: calculate table height
    private func thumbnailImageTitleHeightForRow(row: Int) -> CGFloat{
        
        if lesson.lessonGallery == nil{
            return 0
        }
        let artHistoryImage = lesson.lessonGallery![row]
        
        let titleAttributedString = NSAttributedString(string: artHistoryImage.title, attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue-Medium", size: 22)!])
        
        
        let constraintedSize = CGSize(width: tableView.frame.width-20, height: 9999.0)
        
        let titleHeight = titleAttributedString.boundingRectWithSize(constraintedSize, options: .UsesLineFragmentOrigin, context: nil).height

        return titleHeight
    }
    private func thumbnailImageSubtitleHeightForRow(row: Int) -> CGFloat{
        
        if lesson.lessonGallery == nil{
            return 0
        }
        let artHistoryImage = lesson.lessonGallery![row]
        
        let titleAttributedString = NSAttributedString(string: artHistoryImage.subtitle, attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue-Light", size: 17)!])
        
        let constraintedSize = CGSize(width: tableView.frame.width-30, height: 9999.0)
        
        let titleHeight = titleAttributedString.boundingRectWithSize(constraintedSize, options: .UsesLineFragmentOrigin, context: nil).height
        
        return titleHeight
    }
    private func thumbnailImageHeightForRow(row: Int) -> CGFloat{
        
        if lesson.lessonGallery == nil || lesson.lessonGallery![row].image == nil{
            return 0
        }
        
        let image = lesson.lessonGallery![row].image!
        
        // guard divide by zero
        if image.size.height - 0.0 < 0.001{
            return 0
        }
        
        let ratio = image.size.width / image.size.height
        return tableView.frame.width / ratio
    }
    
    
    private func heightForThumbnailImageCellForRow(row :Int) -> CGFloat{
        
        let titleHeight = thumbnailImageTitleHeightForRow(row)
        let imageHeight = thumbnailImageHeightForRow(row)
        let subtitleHeight = thumbnailImageSubtitleHeightForRow(row)
        
        let totalHeight = 10 + titleHeight + 10 + imageHeight + 10 + subtitleHeight + 10 + 15
        
        return totalHeight
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 1{
            let thumbnailImageCellHeight = heightForThumbnailImageCellForRow(indexPath.row)
            return thumbnailImageCellHeight
        }
        return lessonContentHeight
    }

    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
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

        //calculate new fontsize after adjust headview
        if newHeight < maximumTopViewHeight - 5{
            adjustTitleLabelFontSize()
        }
        
        
        //hide topbar when scroll far than lesson content
        let beginYoffsetThumbnailZone = lessonContentHeight - minimumTopViewHeight
        if scrollView.contentOffset.y > beginYoffsetThumbnailZone{
            let delta = scrollView.contentOffset.y - beginYoffsetThumbnailZone
            topSpace_headViewConstraint.constant = max(-minimumTopViewHeight,-delta)
        }else{
            topSpace_headViewConstraint.constant = 0
        }
        
        
        
        view.layoutIfNeeded()
        
    }
    func adjustTitleLabelFontSize(){
        var titleRect = titleLabel.frame
        titleRect.size.width -= 5
        titleRect.size.height = headView.frame.height - 40
        titleLabel.adjustFontSizeToFitRect(titleRect)
    }
    
}
