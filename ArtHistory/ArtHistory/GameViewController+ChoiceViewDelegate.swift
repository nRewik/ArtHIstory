//
//  GameViewController+ChoiceViewDelegate.swift
//  ArtHistory
//
//  Created by Nutchaphon Rewik on 13/02/2016.
//  Copyright © 2016 Nutchaphon Rewik. All rights reserved.
//

import Foundation

extension GameViewController: ChoiceViewDelegate{
    
    func choiceView(choiceView: ChoiceView, willChangeShowState state: ChoiceViewShowState){
        choiceOutlets.forEach{ $0.userInteractionEnabled = false }
    }
    
    func choiceView(choiceView: ChoiceView, didChangeShowState state: ChoiceViewShowState) {
        
        switch state{
        case .Reveal:
            answerResults += [ choiceView.isCorrectAnswer ]
            animateRevealSubProgressAtIndex(questionIndex)
            choiceOutlets.forEach{ $0.setShowState(.Clear, animated: true)}
        case .Show:
            break
        case .Clear:
            
            if !didPrepareQuestion{
                didPrepareQuestion = true
                
                questionIndex = questionIndex + 1
                if questionIndex >= game.questions.count{
                    // Game is end
                    titleTextView.text = nil
                    animateShowResultScore()
                }else{
                    // Continue to next question
                    prepareChoiceViewForQuestion(currentQuestion)
                    startAnimateCurrentQuestion()
                }
            }
        }
        
        choiceOutlets.forEach{ $0.userInteractionEnabled = true }
    }
}