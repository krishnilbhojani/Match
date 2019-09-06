//
//  ViewController.swift
//  Match
//
//  Created by Krishnil Bhojani on 16/05/19.
//  Copyright © 2019 App Builder. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timerLable: UILabel!
    
    var model = CardModel()
    var cardArray = [Card]()

    var firstFlippedcardIndex:IndexPath?
    
    var timer:Timer?
    var milliseconds:Float = 30 * 1000 // 45 seconds
    
    var soundManager = SoundManager()
    
    @IBAction func replayButton(_ sender: UIButton) {
        
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        self.navigationController?.pushViewController(VC, animated: false)
        
    }
    
    @IBAction func homeButton(_ sender: UIButton) {
        
//        let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        
//        self.navigationController?.pushViewController(homeVC, animated: true)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Call the generated array of card model
        cardArray = model.getCards()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Create Timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        
        RunLoop.main.add(timer!, forMode: .common)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        soundManager.playSound(.suffle)
    }
   
    // MARK: - Timer Methods
    
    @objc func timerElapsed() {
        
        milliseconds -= 1
        
        // Convert to seconds
        let seconds = String(format: "%.2f", milliseconds/1000)
        
        //Set Lable
        timerLable.text = "Time Remaining: \(seconds)"
        
        // When the timer has reached 0...
        if milliseconds <= 0{
            
            // Stops the timer
            timer?.invalidate()
            timerLable.textColor = UIColor.red
            
            // Check if there are any cards unmatched
            checkGameEnded()
            
        }
    }
 
    // MARK:- UICollectionView Protocol Methods

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cardArray.count
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Get an CardCollectionViewCell object
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        // Get the card that the collection view is trying to display
        let card = cardArray[indexPath.row]
        
        // Set the card for the cell
        cell.setCard(card)
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        // Check if any time left
        if milliseconds <= 0{
            return
        }
        
        // Get the cell that the user has selected
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
      
        // Get the card that the user has selected
        let card = cardArray[indexPath.row]
        
        if card.isFlipped == false && card.isMatched == false {
            
            // Flip the card
            cell.flip()
            
            // Play the Flip sound
            soundManager.playSound(.flip)
            
            // Set the Card's status
            card.isFlipped = true
            
            // Determine if it's the first card or the second card that is flipped over
            if firstFlippedcardIndex == nil {
            
                // This is the first card being flipped
                firstFlippedcardIndex = indexPath
                
            }else{
                
                // This is the second card that is being flipped over
                
                // TODO: Perform the matching logic
                checkForMatches(indexPath)
            }
            
        }
    
    }// end of didSelectItenAt class
    
  
    // MARK: - Game logic methods

    func checkForMatches(_ secondFlippedCarsIndex:IndexPath){
        
        // Get the cells for the two cards that were revealed
        let cardOneCell = collectionView.cellForItem(at: firstFlippedcardIndex!) as? CardCollectionViewCell
        
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCarsIndex) as? CardCollectionViewCell
        
        // Get the cards for two cards that were revealed
        let cardOne = cardArray[firstFlippedcardIndex!.row]
        let cardTwo = cardArray[secondFlippedCarsIndex.row]
        
        // Compare the two cards
        if cardOne.imageName == cardTwo.imageName{
            
            // It's a match
            
            // Set the statuses of the cards
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            // Play the match sound
            soundManager.playSound(.match)
            
            // Remove the card from the grid
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            // Check if there are any cards left unmatched
            checkGameEnded()
            
        }else{
            
            // It's not a match
            
            // Set the statuses of the card
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            // Play the nomatch sound
            soundManager.playSound(.nomatch)
            
            // Flip the card back
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
            
        }
        
        // Tell the collectionView to relod the cell of the first card if it is nil
        if cardOneCell == nil{

            collectionView.reloadItems(at: [firstFlippedcardIndex!])
        
      }
        
        // Reset the property that tracks the first card flipped
        firstFlippedcardIndex = nil
    
    } // end of checkForMatches method
    
    func checkGameEnded () {
        
        // Determine if there are any cards unmatched
        var iswon = true
        
        for card in cardArray {
           
            if card.isMatched == false{
                iswon = false
                break
            }
        }
        
        // Messaging variable
        var title = ""
        var message = ""
        
        // If not, then user has won, stop the timer
        if iswon == true {
            
            if milliseconds > 0 {
                timer?.invalidate()
            }
            title = "Congratulation"
            message = "You've won"
            
        }else{
            // If there are unmatched cards, check if there's any time left
            
            if milliseconds > 0 {
                return
            }
            
            title = "Game Over"
            message = "You've lost"
        }
        
        // Show won/lost messaging
        showAlert(title, message)
    
    }
    
  
    func showAlert (_ title:String, _ message:String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
  
}// end of viewController class

