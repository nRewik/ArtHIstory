//
//  ChoiceView.swift
//  ArtHistory
//
//  Created by Nutchaphon Rewik on 07/02/2016.
//  Copyright © 2016 Nutchaphon Rewik. All rights reserved.
//

import UIKit

enum ChoiceViewShowState: String{
    case Show,Reveal,Clear
}

@IBDesignable class ChoiceView: UIView {
    
    // States
    @IBInspectable var image: UIImage?{
        didSet{
            choiceButton.setImage(image, forState: .Normal)
        }
    }
    @IBInspectable var titleText: String?{
        didSet{
            numberLabel.text = titleText
        }
    }
    
    @IBInspectable var IBChoiceViewState: String = ChoiceViewShowState.Clear.rawValue{
        didSet{
            if let IBChoiceViewState = ChoiceViewShowState(rawValue: IBChoiceViewState){
                setShowState(IBChoiceViewState, animated: false)
            }
        }
    }
    
    private var choiceViewState = ChoiceViewShowState.Clear
    
    
    // Properties
    let numberMask = UIView()
    let choiceButtonMask = UIView()
    let revealImageViewMask = UIView()
    let resultViewMask = UIView()
    
    var allMaskViews: [UIView]{
        return [numberMask,choiceButtonMask,revealImageViewMask,resultViewMask]
    }
    
    // IBOutlet
    @IBOutlet weak var numberView: UIView!
    @IBOutlet weak var choiceButton: UIButton!
    @IBOutlet weak var overlayWhiteView: UIView!
    @IBOutlet weak var resultView: UIView!
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    
    // View Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let maskRadius = sqrt( pow(bounds.width, 2) + pow(bounds.height, 2) )
        
        allMaskViews.forEach{
            $0.bounds.size = CGSize(width: maskRadius * 2, height: maskRadius * 2)
            $0.center.x = bounds.width
            $0.center.y = bounds.height
            $0.layer.cornerRadius = maskRadius
        }
    }
    
    
    // Method
    func setShowState(state: ChoiceViewShowState, animated: Bool){
        
        if animated{
            
            switch state{
            case .Show:
                
                view.sendSubviewToBack(numberView)
                
                revealImageViewMask.transform = CGAffineTransformMakeScale(0.001, 0.001)
                resultViewMask.transform = CGAffineTransformMakeScale(0.001, 0.001)
                choiceButtonMask.transform = CGAffineTransformMakeScale(0.001, 0.001)
                
                UIView.animateWithDuration(1.0){
                    self.choiceButtonMask.transform = CGAffineTransformIdentity
                }
                
                
            case .Reveal:
                
                choiceButtonMask.transform = CGAffineTransformMakeScale(1.0, 1.0)
                revealImageViewMask.transform = CGAffineTransformMakeScale(0.001, 0.001)
                resultViewMask.transform = CGAffineTransformMakeScale(0.001, 0.001)
                
                UIView.animateWithDuration(1.0){
                    self.revealImageViewMask.transform = CGAffineTransformIdentity
                    self.resultViewMask.transform = CGAffineTransformIdentity
                }
                
            case .Clear:
                
                numberMask.transform = CGAffineTransformMakeScale(0.001, 0.001)
                numberMask.center = CGPoint.zero // set center to top-left
                    
                view.bringSubviewToFront(numberView)
                
                UIView.animateWithDuration(1.0){
                    self.numberMask.transform = CGAffineTransformIdentity
                }
            }
            
        }else{
            
            switch state{
            case .Show:
                
                view.sendSubviewToBack(numberView)
                
                revealImageViewMask.transform = CGAffineTransformMakeScale(0.001, 0.001)
                resultViewMask.transform = CGAffineTransformMakeScale(0.001, 0.001)
                choiceButtonMask.transform = CGAffineTransformIdentity
                
            case .Reveal:
                
                view.sendSubviewToBack(numberView)
                
                choiceButtonMask.transform = CGAffineTransformIdentity
                revealImageViewMask.transform = CGAffineTransformIdentity
                resultViewMask.transform = CGAffineTransformIdentity
                
            case .Clear:
                
                numberMask.center = CGPoint.zero // set center to top-left
                numberMask.transform = CGAffineTransformIdentity
                view.bringSubviewToFront(numberView)
            }
        }
    }
    
    
    
    // IBActions
    @IBAction func choiceButtonDidTouch(sender: UIButton) {
        setShowState(.Reveal, animated: true)
    }
    
    
    // MARK: Custom View Initilization
    // Our custom view from the XIB file
    lazy var view: UIView = {
        let view = self.loadViewFromNib()
        view.frame = self.bounds
        view.autoresizingMask = [.FlexibleWidth,.FlexibleHeight]
        return view
    }()
    
    func xibSetup() {
        addSubview(view)
        
        //// set up view here
        allMaskViews.forEach{
            $0.backgroundColor = UIColor.blackColor()
            $0.clipsToBounds = true
        }
        
        choiceButton.imageView?.contentMode = .ScaleAspectFill
        choiceButton.imageView?.clipsToBounds = true
        
        
        choiceButton.maskView = choiceButtonMask
        resultView.maskView = resultViewMask
        numberView.maskView = numberMask
        overlayWhiteView.maskView = revealImageViewMask
        
//        revealImageViewMask.transform = CGAffineTransformMakeScale(0.001, 0.001)
//        resultViewMask.transform = CGAffineTransformMakeScale(0.001, 0.001)
        
        setShowState(.Clear, animated: false)
    }
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "ChoiceView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
}
