//
//  Game.swift
//  ArtHistory
//
//  Created by Nutchaphon Rewik on 29/01/2016.
//  Copyright © 2016 Nutchaphon Rewik. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Game{
    
    var questions: [GameQuestion] = []
    
    static func randomGameFromLesson(index: Int)-> Game{
        
        precondition(index >= 1 && index <= 3, "Game must be in 1 to 3")
        
        let dataPath = NSBundle.mainBundle().pathForResource("game-lesson-\(index)", ofType: "json")!
        let data = NSData(contentsOfFile: dataPath)!
        
        let json = JSON(data: data)
        
        let questionPairs = json.map{ string, aQuestion -> (title: String, image: String) in
            let title = aQuestion["title"].stringValue
            let imagePath = aQuestion["image"].stringValue
            return (title: title, image: imagePath)
        }
        
        let images = questionPairs.map{$1}
        
        let otherImagesPath = zip(questionPairs.indices, questionPairs).map{ index, questionPair -> [String] in
            
            var imagesToRandom = images
            imagesToRandom.removeAtIndex(index)
            
            var otherImagePaths: [String] = []
            for _ in 1...3{
                let randomIndex = Int( arc4random_uniform( UInt32(imagesToRandom.count) ) )
                otherImagePaths += [ imagesToRandom[randomIndex] ]
                imagesToRandom.removeAtIndex(randomIndex)
            }
            
            return otherImagePaths
        }
        
        let questions = zip(questionPairs, otherImagesPath).map{ GameQuestion(title: $0.title, correctImagePath: $0.image, otherImagePaths: $1) }
        
        return Game(questions: questions)
    }
}

struct GameQuestion{
    var title = ""
    var correctImagePath = ""
    var otherImagePaths: [String] = []
}





