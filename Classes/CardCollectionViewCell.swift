//
//  CardCollectionViewCell.swift
//  Match
//
//  Created by Krishnil Bhojani on 17/05/19.
//  Copyright © 2019 App Builder. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    var card:Card?
    
    var soundManager = SoundManager()
    
    func setCard (_ card:Card){
        
        // Keep Track of card that gets passed in
        self.card = card
        
        if card.isMatched == true {
            
            // If the card has been matched, then make the image views invisible
            backImageView.alpha = 0
            frontImageView.alpha = 0
            
            return
            
        }else{
            
            // If the card hasn't been matched, then make the image view visible
            backImageView.alpha = 1
            frontImageView.alpha = 1
        }
        
        frontImageView.image = UIImage(named: card.imageName)
        
        // Determine if the card is in flipped up state or in flipped down state
        if card.isFlipped == true{
            
            // Make sure that the backImageView is on top
            UIView.transition(from: backImageView, to: frontImageView, duration: 0, options: [.transitionFlipFromLeft,.showHideTransitionViews], completion: nil)
            
            
        }else{
            // Make sure that the frontImageView is on top
            UIView.transition(from: frontImageView, to: backImageView, duration: 0, options: [.transitionFlipFromRight,.showHideTransitionViews], completion: nil)
        }
        
    }
    func flip(){
        
        UIView.transition(from: backImageView, to: frontImageView, duration: 0.3, options: [.transitionFlipFromLeft,.showHideTransitionViews], completion: nil)
        
    }
    
    func flipBack(){
        
        // Delays the execution
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: 0.3, options: [.transitionFlipFromRight,.showHideTransitionViews], completion: nil)
            
        }
        
    }
    
    func remove(){
        
        // Removes both imageviews from being visible
        backImageView.alpha = 0
        
        // Animate it
        
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {self.frontImageView.alpha = 0}, completion: nil)
        
    }
    
}
