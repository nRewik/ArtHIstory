//
//  GameViewController.swift
//  ArtHistory
//
//  Created by Nutchaphon Rewik on 29/01/2016.
//  Copyright © 2016 Nutchaphon Rewik. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    // States
    var game = Game.randomGameFromLesson(1)
    
    // IBOutlets
    @IBOutlet weak var choiceView1: ChoiceView!
    @IBOutlet weak var choiceView2: ChoiceView!
    @IBOutlet weak var choiceView3: ChoiceView!
    @IBOutlet weak var choiceView4: ChoiceView!
    @IBOutlet var choiceOutlets: [ChoiceView]!
    @IBOutlet weak var titleTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Exclude top-left rectangle for back button
        let exclusionPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 30, height: 30))
        titleTextView.textContainer.exclusionPaths = [exclusionPath]
        
        setChoiceImageForIndex(0)
        print(game.questions.count)
    }
    
    // Method
    func setChoiceImageForIndex(index: Int){
        
        let question = game.questions[index]
        
        titleTextView.text = question.title
        choiceView1.image = UIImage(named: question.correctImagePath)
        choiceView2.image = UIImage(named: question.otherImagePaths[0])
        choiceView3.image = UIImage(named: question.otherImagePaths[1])
        choiceView4.image = UIImage(named: question.otherImagePaths[2])
    }
    
    func animateShowChoiceImages(){
        choiceOutlets.forEach{ $0.setShowState(.Show, animated: true) }
    }
    
    func animateClearChoiceImages(){
        choiceOutlets.forEach{ $0.setShowState(.Clear, animated: true) }
    }
    
    // IBActions
    @IBAction func clearButtonDidTouch() {
        choiceOutlets.forEach{ $0.setShowState(.Clear, animated: true) }
    }
    
    @IBAction func showButtonDidTouch() {
        choiceOutlets.forEach{ $0.setShowState(.Show, animated: true) }
    }
    
    @IBAction func revealButtonDidTouch() {
        choiceOutlets.forEach{ $0.setShowState(.Reveal, animated: true) }
    }
    
}
