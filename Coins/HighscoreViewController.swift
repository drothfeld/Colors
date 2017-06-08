//
//  HighscoreViewController.swift
//  Colors
//
//  Created by Dylan Rothfeld on 2/16/17.
//  Copyright © 2017 Rothfeld. All rights reserved.
//

import UIKit

class HighscoreViewController: UIViewController {
    
    let userDefaults = Foundation.UserDefaults.standard
    
    // View Controller Elements
    @IBOutlet var HS1: UILabel!
    @IBOutlet var HS2: UILabel!
    @IBOutlet var HS3: UILabel!
    @IBOutlet var HS4: UILabel!
    @IBOutlet var HS5: UILabel!
    @IBOutlet var HS6: UILabel!
    @IBOutlet var HS7: UILabel!
    @IBOutlet var HS8: UILabel!
    @IBOutlet var HS9: UILabel!
    @IBOutlet var HS10: UILabel!
    
    @IBOutlet var L1: UILabel!
    @IBOutlet var L2: UILabel!
    @IBOutlet var L3: UILabel!
    @IBOutlet var L4: UILabel!
    @IBOutlet var L5: UILabel!
    @IBOutlet var L6: UILabel!
    @IBOutlet var L7: UILabel!
    @IBOutlet var L8: UILabel!
    @IBOutlet var L9: UILabel!
    @IBOutlet var L10: UILabel!
    
    // View Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadScores()
        loadLevels()
    }
    
    // Load Highscore List
    func loadScores() {
        HS1.text = (userDefaults.string(forKey: "HighscoreONE"))
        HS2.text = (userDefaults.string(forKey: "HighscoreTWO"))
        HS3.text = (userDefaults.string(forKey: "HighscoreTHREE"))
        HS4.text = (userDefaults.string(forKey: "HighscoreFOUR"))
        HS5.text = (userDefaults.string(forKey: "HighscoreFIVE"))
        HS6.text = (userDefaults.string(forKey: "HighscoreSIX"))
        HS7.text = (userDefaults.string(forKey: "HighscoreSEVEN"))
        HS8.text = (userDefaults.string(forKey: "HighscoreEIGHT"))
        HS9.text = (userDefaults.string(forKey: "HighscoreNINE"))
        HS10.text = (userDefaults.string(forKey: "HighscoreTEN"))
    }
    
    // Load Highlevel List
    func loadLevels() {
        L1.text = (userDefaults.string(forKey: "HighlevelONE"))
        L2.text = (userDefaults.string(forKey: "HighlevelTWO"))
        L3.text = (userDefaults.string(forKey: "HighlevelTHREE"))
        L4.text = (userDefaults.string(forKey: "HighlevelFOUR"))
        L5.text = (userDefaults.string(forKey: "HighlevelFIVE"))
        L6.text = (userDefaults.string(forKey: "HighlevelSIX"))
        L7.text = (userDefaults.string(forKey: "HighlevelSEVEN"))
        L8.text = (userDefaults.string(forKey: "HighlevelEIGHT"))
        L9.text = (userDefaults.string(forKey: "HighlevelNINE"))
        L10.text = (userDefaults.string(forKey: "HighlevelTEN"))
    }
    
}
