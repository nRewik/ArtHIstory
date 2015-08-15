//
//  MainItemView.swift
//  ArtHistory
//
//  Created by Nutchaphon Rewik on 7/11/15.
//  Copyright (c) 2015 Nutchaphon Rewik. All rights reserved.
//

import UIKit

@IBDesignable class MainItemView: UIView {
    
    var action: ( () -> Void )?
    var circleCenter: CGPoint{
        return button.center
    }
    
    @IBInspectable var text:String?{
        didSet{
            label?.text = text
        }
    }
    @IBInspectable var image:UIImage?{
        didSet{
            button.imageView?.contentMode = .ScaleAspectFill
            button.setImage(image, forState: .Normal)
        }
    }
    
    @IBAction func buttonPressed() {
        action?()
    }
    
    @IBOutlet weak private var topView: UIView!
    @IBOutlet weak private var button: UIButton!
    @IBOutlet weak private var label: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        
        button.layer.cornerRadius = button.frame.width / 2.0
        button.clipsToBounds = true
    }
    
    // MARK: Custom View Initilization
    // Our custom view from the XIB file
    var view: UIView!
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        addSubview(view)
        //// set up view here
    }
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "MainItemView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
}