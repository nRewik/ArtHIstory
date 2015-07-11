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

class MainViewController: UIViewController {

    
    private let transition = BubbleTransition()
    
    private var itemCenter: CGPoint!
    private var selectedItem: MainItemView!
    
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
        
        var count = 0
        for row in 0..<numberOfRows{
            for col in 0..<numberOfItemsPerRow{
                let xOffset = itemWidth * CGFloat(col)
                let yOffset = rowHeight * CGFloat(row)
                let itemFrame = CGRect(x: xOffset, y: yOffset, width: itemWidth, height: rowHeight)
                let item = MainItemView(frame: itemFrame)
                item.image = getImageFromIndex(count)
                item.text = ["Medival Art","Romesque","The Art of Greece","Early Christian and Bazantine"][count%4]
                item.action = {
                    let localCenter = item.circleCenter
                    self.itemCenter = self.view.convertPoint(localCenter, fromView: item)
                    self.selectedItem = item
                    self.performSegueWithIdentifier("showLesson", sender: nil)
                }
                count++
                scrollView.addSubview(item)
            }
        }
        scrollView.contentSize = CGSize(width: scrollViewWidth, height: rowHeight*5)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupItem()
        let topInset = topView.frame.height + 20.0
        scrollView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        scrollView.setContentOffset( CGPoint(x: 0.0, y: -scrollView.contentInset.top), animated: false)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showLesson"{
            if let lessonVC = segue.destinationViewController as? LessonViewController {
                
                lessonVC.transitioningDelegate = self
                lessonVC.modalPresentationStyle = .Custom
                
                lessonVC.colorTone = selectedItem.image?.getColors()
            }
        }

    }
    
    //MARK: Unwind Segue
    @IBAction func unwindToMainMenu(segue:UIStoryboardSegue){

    }
}

// MARK: UIViewControllerTransitioningDelegate
extension MainViewController: UIViewControllerTransitioningDelegate{
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Present
        transition.startingPoint = itemCenter
        transition.bubbleColor = selectedItem.image?.getColors().backgroundColor ?? UIColor.flatWhiteColor()
        return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Dismiss
        transition.startingPoint = itemCenter
        transition.bubbleColor = selectedItem.image?.getColors().backgroundColor ?? UIColor.flatWhiteColor()
        return transition
    }
}


