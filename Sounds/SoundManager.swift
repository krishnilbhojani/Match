//
//  SoundManager.swift
//  Match
//
//  Created by Krishnil Bhojani on 24/06/19.
//  Copyright © 2019 App Builder. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    
    var audioPlayer:AVAudioPlayer?
    
    enum SoundEffect {
        
        case flip
        case suffle
        case match
        case nomatch
        
    }
    
    func playSound(_ effect:SoundEffect){
        
        var soundFilename = ""
        
        // Determine which sound effect we want to play
        // Add set the appropriate sound filename
        switch effect {
        
        case .flip:
            soundFilename = "cardflip"
            
        case .match:
            soundFilename = "dingcorrect"
            
        case .nomatch:
            soundFilename = "dingwrong"
            
        case .suffle:
            soundFilename = "shuffle"
        
        }
        
        
        // Get the path to the sound file inside the bundle
        let bundlePath = Bundle.main.path(forResource: soundFilename, ofType: "wav")
        
        guard bundlePath != nil else {
            print("Couldn't find sound file \(soundFilename) in the bundle")
            return
        }
      
        // Create a URL object from this string path
        let soundURL = URL(fileURLWithPath: bundlePath!)
        
        do{
            // Create audio player object
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
        
            audioPlayer?.play()
        }
        catch{
            
            // Couldn't create audio player object, log the error
            print("Couldn't create audio player object for sound file \(soundFilename)")
        }
    }
    
}
