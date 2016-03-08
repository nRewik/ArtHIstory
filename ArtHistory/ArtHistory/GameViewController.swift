//
//  GameViewController.swift
//  ArtHistory
//
//  Created by Nutchaphon Rewik on 29/01/2016.
//  Copyright © 2016 Nutchaphon Rewik. All rights reserved.
//

import UIKit
import FontAwesome_swift

class GameViewController: UIViewController {
  
  // States
  var questionIndex = 0
  var canAnswerQuestion = false{
    didSet{
      choiceButtons.forEach{ $0.userInteractionEnabled = canAnswerQuestion}
    }
  }
  var game: Game!
  var answerResults: [Bool] = []
  
  var correctAnswerIndex: Int = 0
  var choiceButtonMap: [UIButton:Int] = [:]
  
  // Properties
  var currentQuestion: GameQuestion{
    return game.questions[questionIndex]
  }
  var subProgressViews: [UIView] = []
  
  // IBOutlets
  @IBOutlet weak var backButton: UIButton!
  
  @IBOutlet weak var choice1Button: UIButton!
  @IBOutlet weak var choice2Button: UIButton!
  @IBOutlet weak var choice3Button: UIButton!
  @IBOutlet weak var choice4Button: UIButton!
  @IBOutlet var choiceButtons: [UIButton]!
  @IBOutlet var choiceImageViews: [UIImageView]!
  
  
  @IBOutlet weak var titleTextView: UITextView!
  
  @IBOutlet weak var progressView: UIView!
  @IBOutlet weak var scoreView: UIView!
  
  @IBOutlet weak var dimView: UIView!
  
  
  @IBOutlet weak var scoreLabel: UILabel!
  @IBOutlet weak var maxScoreLabel: UILabel!
  @IBOutlet weak var scoreBackButton: UIButton!
  @IBOutlet weak var scoreCenterXconstraint: NSLayoutConstraint!
  @IBOutlet weak var maxScoreCenterXconstraint: NSLayoutConstraint!
  @IBOutlet weak var separatorViewLeadingConstraint: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    // Exclude top-left rectangle for back button
    let exclusionPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 30, height: 28))
    titleTextView.textContainer.exclusionPaths = [exclusionPath]
    
    backButton.titleLabel?.font = UIFont.fontAwesomeOfSize(30)
    backButton.setTitle(String.fontAwesomeIconWithName(.ChevronCircleLeft), forState: .Normal)
    
    maxScoreLabel.text = "\(game.questions.count)"
    
    scoreBackButton.titleLabel?.font = UIFont.fontAwesomeOfSize(60)
    scoreBackButton.setTitle(String.fontAwesomeIconWithName(.ArrowCircleLeft), forState: .Normal)
    
    subProgressViews = game.questions.map{_ in UIView()}
    subProgressViews.forEach(view.addSubview)
    
    // Bring dimView and scoreView above recently add subProgressViews
    view.bringSubviewToFront(dimView)
    view.bringSubviewToFront(scoreView)
    
    choiceButtonMap = [choice1Button,choice2Button,choice3Button,choice4Button]
      .enumerate()
      .reduce([:]){ map, x -> [UIButton:Int] in
        var new_map = map
        new_map[x.element] = x.index
        return new_map
    }
    
    choiceButtons.forEach{
      $0.layer.borderWidth = 2.0
      $0.layer.borderColor = UIColor.blackColor().CGColor
      $0.imageView?.contentMode = .ScaleAspectFit
    }
    
    prepareChoiceViewForQuestion(currentQuestion)
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "startAnimateCurrentQuestion", userInfo: nil, repeats: false)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    let yOffset = progressView.frame.origin.y
    let width = view.bounds.width / CGFloat(subProgressViews.count)
    for (index,subProgressView) in subProgressViews.enumerate(){
      let xOffset = CGFloat(index) * width
      subProgressView.frame = CGRect(x: xOffset, y: yOffset, width: width, height: progressView.bounds.height)
    }
    
    for (index,result) in answerResults.enumerate(){
      let color = result ? UIColor.flatGreenColor() : UIColor.flatWatermelonColor()
      subProgressViews[index].backgroundColor = color
    }
    
    scoreView.layer.cornerRadius = scoreView.bounds.width / 2.0
  }
  
  // Method
  func animateShowResultScore(){
    scoreLabel.text = "\(answerResults.filter{ $0 == true }.count)"
    
    UIView.animateWithDuration(0.75,
      animations: {
        self.dimView.alpha = 0.85
        self.scoreView.alpha = 1.0
      },
      completion: { finish in
        
        [self.scoreCenterXconstraint,self.maxScoreCenterXconstraint].forEach{ $0.constant += 25 }
        self.separatorViewLeadingConstraint.constant += 50
        
        UIView.animateWithDuration(0.6,
          animations: {
            self.scoreBackButton.alpha = 1.0
            self.view.layoutIfNeeded()
          }, completion: nil)
    })
  }
  
  
  func animateRevealSubProgressAtIndex(index: Int){
    let color = answerResults[index] ? UIColor.flatGreenColor() : UIColor.flatWatermelonColor()
    UIView.animateWithDuration(1.0){
      self.subProgressViews[index].backgroundColor = color
    }
  }
  
  func prepareChoiceViewForQuestion(question: GameQuestion){
    
    let randomIndex = Int(arc4random_uniform(UInt32(4)))
    var indices = [0,1,2,3]
    
    let correctIndex = indices[randomIndex]
    let otherIndices = indices.filter{ $0 != randomIndex}
    
    choiceImageViews[correctIndex].image = UIImage(named: question.correctImagePath)
    correctAnswerIndex = correctIndex
    
    let otherChoiceButtons = otherIndices.map{ choiceImageViews[$0] }
    
    zip(otherChoiceButtons, question.otherImagePaths).forEach{ choiceImageView, imagePath in
      choiceImageView.image = UIImage(named: imagePath)
    }
    
  }
  
  func startAnimateCurrentQuestion(){
    canAnswerQuestion = false
    animateTypeWriter(currentQuestion.title, currentCursorIndex: 0, textView: titleTextView, interval: 0.025)
  }
  
  func animateTypeWriter(text: String, currentCursorIndex: Int, textView: UITextView, interval: NSTimeInterval){
    
    // Show choice images after finish show all text
    guard currentCursorIndex <= (text as NSString).length else {
      return canAnswerQuestion = true
    }
    
    let clearTextAttribute = [NSForegroundColorAttributeName:UIColor.clearColor()]
    let attributedText = NSMutableAttributedString(string: text, attributes: clearTextAttribute)
    
    let blackTextNSRange = NSRange(location: 0, length: currentCursorIndex)
    let blackTextAttribute = [NSForegroundColorAttributeName:UIColor.blackColor()]
    
    attributedText.setAttributes(blackTextAttribute, range: blackTextNSRange)
    
    UIView.animateWithDuration(interval,
    animations: {
      textView.attributedText = attributedText
    },
    completion: { [weak self] finish in
      self?.animateTypeWriter(text, currentCursorIndex: currentCursorIndex + 1, textView: textView, interval: interval)
    })
  }
  
  func showNextQuestion(){
    choiceImageViews.forEach{ $0.alpha = 1.0 }
    prepareChoiceViewForQuestion(currentQuestion)
    startAnimateCurrentQuestion()
  }
  
  
  @IBAction func choiceButtonDidTouch(sender: UIButton, forEvent event: UIEvent) {
    guard let answerIndex = choiceButtonMap[sender] else { return }
    
    answerResults += [answerIndex == correctAnswerIndex]
    animateRevealSubProgressAtIndex(questionIndex)
    
    questionIndex = questionIndex + 1
    if questionIndex >= game.questions.count{
      // Game is end
      titleTextView.text = nil
      animateShowResultScore()
    }else{
      // Continue to next question
      UIView.animateWithDuration(0.6,
      animations: {
        self.choiceImageViews[answerIndex].alpha = 0.4
      },
      completion: { finish in
        NSTimer.scheduledTimerWithTimeInterval(0.6, target: self, selector: "showNextQuestion", userInfo: nil, repeats: false)
      })
    }
  }
  
  
}

