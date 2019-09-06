//
//  File.swift
//  Match
//
//  Created by Krishnil Bhojani on 16/05/19.
//  Copyright © 2019 App Builder. All rights reserved.
//

import Foundation

class CardModel {
    
    func getCards() -> [Card] {
        
        // Declare an array to store the numbers we've already generated
        var generatedNumbersArray = [Int]()
        
        // Declare an array to store the generated cards
        var generatedCardsArray = [Card]()
        
        // Randomly generated pairs of cards
        while(generatedNumbersArray.count < 10){
            let randomNumber = arc4random_uniform(13)+1
            
            // Make it so we only have unique pairs of card
            if generatedNumbersArray.contains(Int(randomNumber)) == false {
                
                // Printing the random Number
                print(randomNumber)
                
                // Store the number into generatedNumbersArray
                generatedNumbersArray.append(Int(randomNumber))
                
                // Create the first Card object
                let cardOne = Card()
                cardOne.imageName = "card\(randomNumber)"
                generatedCardsArray.append(cardOne)
                
                // Create the Second Card object
                let cardTwo = Card()
                cardTwo.imageName = "card\(randomNumber)"
                generatedCardsArray.append(cardTwo)
                
            }
            
        }
        // Randomise the array
        for i in 0...generatedCardsArray.count-1{
            
            // FInd a random index to swap with
            let randomNumber = Int(arc4random_uniform(UInt32(generatedCardsArray.count)))
            
            // Swap the two cards
            let temporaryStorage = generatedCardsArray[i]
            generatedCardsArray[i] = generatedCardsArray[randomNumber]
            generatedCardsArray[randomNumber] = temporaryStorage
        }
        
        // Return the array
        return generatedCardsArray
    }
    
}
