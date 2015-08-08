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
    
    var selectedIndexPath: NSIndexPath?
    
    var colorTone: UIImageColors!
    let transition = BubbleTransition()
    
    var lessonContentHeight: CGFloat{
        return 500
    }
    var minimumTopViewHeight: CGFloat{
        return 65.0
    }
    var maximumTopViewHeight: CGFloat{
        return 150.0
    }
    
    @IBOutlet weak var topSpace_headViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint_headView: NSLayoutConstraint!
    
    @IBOutlet weak var headView: UIView!
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
        backButton.titleLabel?.font = UIFont.fontAwesomeOfSize(30.0)
        backButton.setTitle(String.fontAwesomeIconWithName(.ChevronCircleLeft), forState: .Normal)
        
        // tableView.rowHeight = UITableViewAutomaticDimension
        // tableView.estimatedRowHeight = 44.0
        
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
        backButton.setTitleColor(colorTone.backgroundColor, forState: .Normal)
        titleLabel.textColor = colorTone.backgroundColor
        
        flatifyAndContrast()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showGallery"{
            if let lessonVC = segue.destinationViewController as? GalleryViewController {
                
                lessonVC.transitioningDelegate = self
                lessonVC.modalPresentationStyle = .Custom
            }
        }
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
            return 10
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0{
            let contentCell = tableView.dequeueReusableCellWithIdentifier("LessonContentTableViewCell") as! LessonContentTableViewCell
            
            contentCell.contentText = "เกรดเปราะบางเฟอร์นิเจอร์ รันเวย์ไคลแม็กซ์ไคลแม็กซ์ ไฟต์ทัวร์นาเมนท์อยุติธรรมเปเปอร์นพมาศ ตุ๊กตุ๊กอิสรชนช็อปปิ้ง บาร์บี้ พุทธภูมิ เอฟเฟ็กต์ตุ๊กตุ๊กเมคอัพ กลาสบุ๋นโบว์ลิ่งจัมโบ้พิซซ่า หม่านโถว โยโย่ธรรมาภิบาลแอปเปิล ควิกสโตร์แฮปปี้ สตีลโพลารอยด์ คอลัมน์แซมบ้าซิตี อีโรติกแพนงเชิญโดนัทเทค\n\nโนแครต คาเฟ่แบล็กเยนจ๊าบ เมจิคนพมาศแบล็ก แคร็กเกอร์ภูมิทัศน์บอกซ์แบ็กโฮเอ็กซ์โป ผิดพลาดเทรลเลอร์ ขั้นตอน แดนเซอร์ป๊อปฮ็อต บรรพชนฟยอร์ดกฤษณ์ แอ็คชั่นคำตอบโต๊ะจีน แคมเปญถ่ายทำเพลย์บอย ไดเอ็ต ดีเจ แต๋วไวอะกร้าเซ็กส์ลิมูซีนรามาธิบดี ไกด์ธัมโม รีพอร์ทฟิวเจอร์โอวัลตินล็อต แจ๊กพ็อตออทิสติกขั้นตอนมั้งบร็อกโคลี แอดมิสชันคำตอบ ฮอตดอก บึ้มมะกันเสกสรรค์ดิกชันนารีเพลย์บอย ดีไซน์เนอร์สเตชั่นลอจิสติกส์ซิลเวอร์ บอกซ์มาราธอนดีกรีอพาร์ตเมนต์เมคอัพ ไฟแนนซ์เจี๊ยว\n\nวอลซ์ไฮไลต์ แลนด์วิก อ่วมก่อนหน้า ฮาร์ดแอดมิชชั่น เซ็กส์เอาต์ทริป เวิลด์กรอบรูป สเตอริโอเรซินฮาร์ดแซมบ้าไบเบิล ธุหร่ำ สัมนาผ้าห่ม ตรวจสอบโรลออน ช็อปปิ้งวีซ่า﻿กรรมาชนชนะเลิศเซฟตี้ น็อค สปาแพกเกจวอฟเฟิล วินแรงใจ แฟ้บเซ็กซี่ยูวี ว้อดก้านินจาโปรสหัสวรรษอพาร์ตเมนต์ แมชีนเลกเชอร์ ทอร์นาโดโปรดักชั่นบลูเบอร์\n\nรีชินบัญชร ซีเนียร์สจ๊วตฮีโร่ อึมครึม วีซ่าธรรมาภิบาลฟลุตโปรโมเตอร์ วีซ่าฮ่องเต้โซน เบิร์นเอ็นทรานซ์สเตชั่นเบลอไทเฮา ฟลุคป๊อกไฮเปอร์อุปการคุณ บิ๊ก ดิสเครดิตแมชชีนบูติกดีพาร์ทเมนต์วีไอพี ช็อปเปอร์ช็อปเปอร์ เทปบาร์บีคิวโก๊ะแจ๊กพอตสะบึมส์ ซีนเจ๊าะแจ๊ะจูนแฟ็กซ์ เบญจมบพิตร เอ๊าะอุรังคธาตุช็อต โอเวอร์ฟิวเจอร์\n\nพาเหรด โทร จิ๊กโก๋สปาย เจ็ตเฟอร์นิเจอร์ ภคันทลาพาธโปรเจกเตอร์ วอเตอร์เซ็กซี่ ลอจิสติกส์ตื้บเสือโคร่งลาติน ไทยแลนด์มัฟฟินซิ้ม ตรวจทานเคลื่อนย้ายลอร์ด เฟอร์รี่คาสิโนบัลลาสต์โฮลวีต พาสตาละติน ริกเตอร์ สี่แยกวิลล์ราเมนโบรกเกอร์ไชน่า เฟิร์มชีสตังค์ ดีไซน์เวิลด์"
            
            return contentCell
        }
        
        if indexPath.section == 1{
            
            let thumbnailImageCell = tableView.dequeueReusableCellWithIdentifier("ThumbnailImageTableViewCell") as! ThumbnailImageTableViewCell

            thumbnailImageCell.thumbnailImage = Lesson.getImageFromIndex(indexPath.row)
            thumbnailImageCell.title = "Writing your name with MyNamePix is easy and fast."
            
            return thumbnailImageCell
        }
        
        return UITableViewCell()
    }
    
}

//MARK: TableView Delegate
extension LessonViewController: UITableViewDelegate{
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 1{

            let thumbnailHeight = view.frame.height / 5.0
            let expandThumbnailHeight: CGFloat = 250.0
            
            if let selectedIndexPath = selectedIndexPath{
                return selectedIndexPath == indexPath ? expandThumbnailHeight : thumbnailHeight
            }
            return thumbnailHeight
        }
        return lessonContentHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section != 1{
            return
        }

        var isDeselectedThumbnail = false
        if let selectedIndexPath = selectedIndexPath{
            if selectedIndexPath == indexPath{
                isDeselectedThumbnail = true
            }
        }
        
        if isDeselectedThumbnail{
            selectedIndexPath = nil
        }else{
            selectedIndexPath = indexPath
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Middle, animated: true)
    }
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return indexPath.section != 0 ? indexPath : nil
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

// MARK: UIViewControllerTransitioningDelegate
extension LessonViewController: UIViewControllerTransitioningDelegate{
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Present
//        transition.startingPoint = view.convertPoint(playGalleryButton.center, fromView: playGalleryView)
        transition.bubbleColor = colorTone.backgroundColor
        return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Dismiss
//        transition.startingPoint = view.convertPoint(playGalleryButton.center, fromView: playGalleryView)
        transition.bubbleColor = colorTone.backgroundColor
        return transition
    }
}
