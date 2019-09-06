//
//  HomeViewController.swift
//  Match
//
//  Created by Krishnil Bhojani on 28/08/19.
//  Copyright © 2019 App Builder. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isTranslucent = false

        let randomNumber = Int(arc4random_uniform(12)+1)
        
        image.image = UIImage(named: "card\(randomNumber)")
        
    }
    
    @IBAction func playButton(_ sender: UIButton) {
        
        let gameVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        self.navigationController?.pushViewController(gameVC, animated: true)
    }
    
    @IBAction func settingsButton(_ sender: UIButton) {
        
        let settingsVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        
        self.navigationController?.pushViewController(settingsVC, animated: true)
        
    }
    
    @IBAction func quitButton(_ sender: UIButton) {
        exit(0)
    }
    
}
