//
//  ViewController.swift
//  Coins
//
//  Created by Dylan Rothfeld on 1/28/17.
//  Copyright © 2017 Rothfeld. All rights reserved.
//

import UIKit
import AVFoundation

var themeMusic: AVAudioPlayer!

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Getting audio file
        let path = Bundle.main.path(forResource: "themeMusic.wav", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        // Playing audio file
        do {
            let sound = try AVAudioPlayer(contentsOf: url)
            themeMusic = sound
            sound.play()
            
        // Audio file not found
        } catch {
            NSLog("Sound file not found")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

