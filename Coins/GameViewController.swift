//
//  GameViewController.swift
//  Colors
//
//  Created by Dylan Rothfeld on 1/28/17.
//  Copyright © 2017 Rothfeld. All rights reserved.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController {
    
    // Device Values
    let screenWidth  = UIScreen.main.fixedCoordinateSpace.bounds.width
    let screenHeight = UIScreen.main.fixedCoordinateSpace.bounds.height
    
    // Audio Values
    var colorSound: AVAudioPlayer!
    
    
    // View Controller Elements
    @IBOutlet var labelScore: UILabel!
    @IBOutlet var labelLevel: UILabel!
    @IBOutlet var labelTarget: UILabel!
    @IBOutlet var redLifeImage: UIImageView!
    @IBOutlet var yellowLifeImage: UIImageView!
    @IBOutlet var orangeLifeImage: UIImageView!
    @IBOutlet var greenLifeImage: UIImageView!
    @IBOutlet var blueLifeImage: UIImageView!
    @IBOutlet var purpleLifeImage: UIImageView!
    @IBOutlet var pinkLifeImage: UIImageView!
    @IBOutlet var whiteLifeImage: UIImageView!
    @IBOutlet var gameOverImageBackground: UIImageView!
    @IBOutlet var gameOverLabel: UILabel!
    @IBOutlet var gameOverButton: UIButton!
    @IBOutlet var labelNewHighScore: UILabel!
    
    // Timer Values
    var blockUpdateInterval = 0.005
    var targetUpdateInterval = 1.50
    
    var updateBlockTimer : Timer = Timer()
    var updateTargetTimer: Timer = Timer()
    
    // Game Values
    var speedFlag = -1
    var score = 0
    var level = 1
    var target = 0
    var lives = 9
    var targetCounter = 0
    var targetTextColor = 0
    var blockSelector = 0
    var sizeMultiplier = 1
    var speedMultiplier = 1
    var specialMultiplier = 1
    var redLife = 0
    var yellowLife = 0
    var orangeLife = 0
    var greenLife = 0
    var blueLife = 0
    var purpleLife = 0
    var pinkLife = 0
    var whiteLife = 0
    
    // Saved Data
    var HighscoreONE = 0
    var HighscoreTWO = 0
    var HighscoreTHREE = 0
    var HighscoreFOUR = 0
    var HighscoreFIVE = 0
    var HighscoreSIX = 0
    var HighscoreSEVEN = 0
    var HighscoreEIGHT = 0
    var HighscoreNINE = 0
    var HighscoreTEN = 0
    
    var HighlevelONE = 0
    var HighlevelTWO = 0
    var HighlevelTHREE = 0
    var HighlevelFOUR = 0
    var HighlevelFIVE = 0
    var HighlevelSIX = 0
    var HighlevelSEVEN = 0
    var HighlevelEIGHT = 0
    var HighlevelNINE = 0
    var HighlevelTEN = 0
    
    // Block Objects
    var blockCountStart = 50
    var blockList = [block]()
    
    // View Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetGameValues()
        loadScores()
        makeBlocks(blockCount: blockCountStart)
        makeTimers()
        
    }
    
    // Updating Block Positions
    func updateBlocks() {
        for block in blockList {
            block.object.frame.origin.y += CGFloat(block.speed)
            
            // Reset Movement after Frozen Level
            if level % 10 == 1 {
                block.speed = Double(arc4random_uniform(3) + 2)
            }
            
            // Checking Block Positions
            if block.object.frame.origin.y > CGFloat(screenHeight) && block.color != blockSelector {
                
                // Updating Level Theme
                switch level {
                    
                    // Half Speed
                    case 3:
                        block.speed = Double(arc4random_uniform(2) + 1)
                    // Double Speed
                    case 6:
                        block.speed = Double(arc4random_uniform(6) + 4)
                        specialMultiplier = 3
                    // Frozen in Place
                    case 10:
                        block.speed = 0
                    // Moving Backward
                    case 12:
                        block.speed = Double(arc4random_uniform(3) + 2)
                    // Normal Speed
                    default:
                        block.speed = Double(arc4random_uniform(3) + 2)
                        specialMultiplier = 1
                }
                
                // Reset Block Position
                block.object.frame.origin.x = CGFloat(Int(arc4random_uniform(UInt32(Int(screenWidth)) - 25) + 10))
                block.object.frame.origin.y = CGFloat(-1 * Int(arc4random_uniform(50) + 25))
            }
                
            // Reset Inverse Block Position    
            else if block.object.frame.origin.y < CGFloat(0) && block.color == blockSelector {
                block.object.frame.origin.x = CGFloat(Int(arc4random_uniform(UInt32(Int(screenWidth)) - 25) + 10))
                block.object.frame.origin.y = CGFloat(Int(arc4random_uniform(UInt32(Int(screenHeight + 25))) + UInt32(Int(screenHeight))))
            }
        }
    }
    
    // Updating Score
    func updateScore(blockTapped: block, scoreMultiplier: Int) {
        
        // Calculating Size Multiplier
        if blockTapped.size >= 40 { sizeMultiplier = 1 }
        else if blockTapped.size >= 30 && blockTapped.size < 40 { sizeMultiplier = 2 }
        else if blockTapped.size >= 20 && blockTapped.size < 30 { sizeMultiplier = 3 }
        else if blockTapped.size >= 10 && blockTapped.size < 20 { sizeMultiplier = 4 }
        
        // Calculating Score
        score += scoreMultiplier * blockTapped.color * sizeMultiplier * speedMultiplier * specialMultiplier
        labelScore.text = String(score)
        
        
        
    }
    
    // Updating Level
    func updateLevel() {
        if targetCounter % 5 == 0 {
            level += 1
            labelLevel.text = String(level)
            speedFlag *= -1
            blockSelector = 0
        }
        
        // Changing Level Theme
        switch level {
            
            // All Blocks Have 1/2 Speed
            case 3:
                if speedFlag == 1 {
                    for block in blockList {
                        block.speed /= 2.00
                    }
                    speedFlag = -1
                }
            // All Blocks have 2X Speed
            case 6:
                if speedFlag == 1 {
                    for block in blockList {
                        block.speed *=  2
                    }
                    speedFlag = -1
                }
            // All Blocks have 0 Speed
            case 10:
                if speedFlag == 1 {
                    for block in blockList {
                        block.speed = 0
                    }
                    speedFlag = -1
                }
            // A Single Block Color Moves Backward
            case 12:
                if speedFlag == 1 {
                    blockSelector = Int(arc4random_uniform(8) + 1)
                    for block in blockList {
                        if blockSelector == block.color {
                            block.speed *= -1
                        }
                    }
                speedFlag = -1
                }
            
            // Blocks Behave Normally
            default:
                break
        }
    }
    
    // Updating Target
    func updateTarget() {
        targetCounter += 1
        updateLevel()
        labelTarget.center.x = CGFloat(arc4random_uniform(UInt32(Int(screenWidth)) - 30) + 30)
        labelTarget.center.y = CGFloat(arc4random_uniform(UInt32(Int(screenHeight)) - 30) + 30)
        labelTarget.font = labelTarget.font.withSize(CGFloat(arc4random_uniform(40) + 10))
        labelTarget.transform = CGAffineTransform(rotationAngle: CGFloat.pi / CGFloat(arc4random_uniform(UInt32(Int(10))) + 1))
        target = Int(arc4random_uniform(8) + 1)
        targetTextColor = Int(arc4random_uniform(8) + 1)
        
        switch target {
            case 1:
                labelTarget.text = "Red"
                // Getting audio file
                let path = Bundle.main.path(forResource: "audioRed.wav", ofType:nil)!
                let url = URL(fileURLWithPath: path)
                
                // Playing audio file
                do {
                    let sound = try AVAudioPlayer(contentsOf: url)
                    colorSound = sound
                    sound.play()
                    
                    // Audio file not found
                } catch {
                    NSLog("Audio File note found")
                }
            
            case 2:
                labelTarget.text = "Yellow"
                // Getting audio file
                let path = Bundle.main.path(forResource: "audioYellow.wav", ofType:nil)!
                let url = URL(fileURLWithPath: path)
                
                // Playing audio file
                do {
                    let sound = try AVAudioPlayer(contentsOf: url)
                    colorSound = sound
                    sound.play()
                    
                    // Audio file not found
                } catch {
                    NSLog("Audio File note found")
                }
            
            case 3:
                labelTarget.text = "Orange"
                // Getting audio file
                let path = Bundle.main.path(forResource: "audioOrange.wav", ofType:nil)!
                let url = URL(fileURLWithPath: path)
                
                // Playing audio file
                do {
                    let sound = try AVAudioPlayer(contentsOf: url)
                    colorSound = sound
                    sound.play()
                    
                    // Audio file not found
                } catch {
                    NSLog("Audio File note found")
                }
            
            case 4:
                labelTarget.text = "Green"
                // Getting audio file
                let path = Bundle.main.path(forResource: "audioGreen.wav", ofType:nil)!
                let url = URL(fileURLWithPath: path)
                
                // Playing audio file
                do {
                    let sound = try AVAudioPlayer(contentsOf: url)
                    colorSound = sound
                    sound.play()
                    
                    // Audio file not found
                } catch {
                    NSLog("Audio File note found")
                }

            case 5:
                labelTarget.text = "Blue"
                // Getting audio file
                let path = Bundle.main.path(forResource: "audioBlue.wav", ofType:nil)!
                let url = URL(fileURLWithPath: path)
                
                // Playing audio file
                do {
                    let sound = try AVAudioPlayer(contentsOf: url)
                    colorSound = sound
                    sound.play()
                    
                    // Audio file not found
                } catch {
                    NSLog("Audio File note found")
                }

            case 6:
                labelTarget.text = "Purple"
                // Getting audio file
                let path = Bundle.main.path(forResource: "audioPurple.wav", ofType:nil)!
                let url = URL(fileURLWithPath: path)
                
                // Playing audio file
                do {
                    let sound = try AVAudioPlayer(contentsOf: url)
                    colorSound = sound
                    sound.play()
                    
                    // Audio file not found
                } catch {
                    NSLog("Audio File note found")
                }

            case 7:
                labelTarget.text = "Pink"
                // Getting audio file
                let path = Bundle.main.path(forResource: "audioPink.wav", ofType:nil)!
                let url = URL(fileURLWithPath: path)
                
                // Playing audio file
                do {
                    let sound = try AVAudioPlayer(contentsOf: url)
                    colorSound = sound
                    sound.play()
                    
                    // Audio file not found
                } catch {
                    NSLog("Audio File note found")
                }

            case 8:
                labelTarget.text = "White"
                // Getting audio file
                let path = Bundle.main.path(forResource: "audioWhite.wav", ofType:nil)!
                let url = URL(fileURLWithPath: path)
                
                // Playing audio file
                do {
                    let sound = try AVAudioPlayer(contentsOf: url)
                    colorSound = sound
                    sound.play()
                    
                    // Audio file not found
                } catch {
                    NSLog("Audio File note found")
                }

            default:
                labelTarget.text = "White"
        }
        
        switch targetTextColor {
            case 1:
                labelTarget.textColor = UIColor.red
            case 2:
                labelTarget.textColor = UIColor.yellow
            case 3:
                labelTarget.textColor = UIColor.orange
            case 4:
                labelTarget.textColor = UIColor.green
            case 5:
                labelTarget.textColor = UIColor.blue
            case 6:
                labelTarget.textColor = UIColor.purple
            case 7:
                labelTarget.textColor = UIColor.magenta
            case 8:
                labelTarget.textColor = UIColor.white
            case 9:
                labelTarget.textColor = UIColor.brown
            case 10:
                labelTarget.textColor = UIColor.cyan
            default:
                labelTarget.textColor = UIColor.cyan
        }
    }
    
    // Creates and Draws Blocks
    func makeBlocks(blockCount: Int) {
        for _ in 1...blockCount {
            blockList.append(block())
        }
        for block in blockList {
            self.view.addSubview(block.object)
            
            block.object.isUserInteractionEnabled = true
            
            let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.tap))
            singleTap.numberOfTapsRequired = 1
            singleTap.numberOfTouchesRequired = 1
            
            block.object.addGestureRecognizer(singleTap)
        }
    }
    
    // Creates and Starts Timers
    func makeTimers() {
        updateBlockTimer = Timer.scheduledTimer(timeInterval: blockUpdateInterval, target: self, selector: #selector(self.updateBlocks), userInfo: nil, repeats: true)
        updateTargetTimer = Timer.scheduledTimer(timeInterval: targetUpdateInterval, target: self, selector: #selector(self.updateTarget), userInfo: nil, repeats: true)
        
    }
    
    // Load Scores
    func loadScores() {
        let userDefaults = Foundation.UserDefaults.standard
        HighscoreONE = (userDefaults.integer(forKey: "HighscoreONE"))
        HighscoreTWO = (userDefaults.integer(forKey: "HighscoreTWO"))
        HighscoreTHREE = (userDefaults.integer(forKey: "HighscoreTHREE"))
        HighscoreFOUR = (userDefaults.integer(forKey: "HighscoreFOUR"))
        HighscoreFIVE = (userDefaults.integer(forKey: "HighscoreFIVE"))
        HighscoreSIX = (userDefaults.integer(forKey: "HighscoreSIX"))
        HighscoreSEVEN = (userDefaults.integer(forKey: "HighscoreSEVEN"))
        HighscoreEIGHT = (userDefaults.integer(forKey: "HighscoreEIGHT"))
        HighscoreNINE = (userDefaults.integer(forKey: "HighscoreNINE"))
        HighscoreTEN = (userDefaults.integer(forKey: "HighscoreTEN"))
    }
    
    // Resets Game Values
    func resetGameValues() {
        score = 0
        level = 1
        lives = 9
        speedFlag = -1
        targetCounter = 0
        targetTextColor = 0
        blockSelector = 0
        labelScore.text = String(score)
        target = Int(arc4random_uniform(8) + 1)
        redLifeImage.isHidden = true
        yellowLifeImage.isHidden = true
        orangeLifeImage.isHidden = true
        greenLifeImage.isHidden = true
        blueLifeImage.isHidden = true
        purpleLifeImage.isHidden = true
        pinkLifeImage.isHidden = true
        whiteLifeImage.isHidden = true
        redLife = 0
        yellowLife = 0
        orangeLife = 0
        greenLife = 0
        blueLife = 0
        purpleLife = 0
        pinkLife = 0
        whiteLife = 0
        
    }
    
    func resetBlock(blockTapped: block) {
        blockTapped.object.frame.origin.x = CGFloat(Int(arc4random_uniform(UInt32(Int(screenWidth)) - 25) + 10))
        blockTapped.object.frame.origin.y = CGFloat(-1 * Int(arc4random_uniform(50) + 25))
        blockTapped.color = Int(arc4random_uniform(8) + 1)
        blockTapped.speed = Double(arc4random_uniform(3) + 2)
        blockTapped.size = Int(arc4random_uniform(50) + 10)
        
        switch blockTapped.color {
            case 1:
                blockTapped.blockImage = UIImage(named: "block_red.png")!
            case 2:
                blockTapped.blockImage = UIImage(named: "block_yellow.png")!
            case 3:
                blockTapped.blockImage = UIImage(named: "block_orange.png")!
            case 4:
                blockTapped.blockImage = UIImage(named: "block_green.png")!
            case 5:
                blockTapped.blockImage = UIImage(named: "block_blue.png")!
            case 6:
                blockTapped.blockImage = UIImage(named: "block_purple.png")!
            case 7:
                blockTapped.blockImage = UIImage(named: "block_pink.png")!
            case 8:
                blockTapped.blockImage = UIImage(named: "block_white.png")!
            default:
                blockTapped.blockImage = UIImage(named: "block_white.png")!
        }
    }
    
    // User Touch Interatction
    func tap(gestureRecognizer: UITapGestureRecognizer) {
        let tappedBlock = block()
        let tappedImageView = gestureRecognizer.view!
        
        tappedBlock.object = tappedImageView as! UIImageView
        
        // Finding Color Value
        if tappedBlock.object.image == UIImage(named: "block_red.png")! {
            tappedBlock.color = 1
        }
        else if tappedBlock.object.image == UIImage(named: "block_yellow.png")! {
            tappedBlock.color = 2
        }
        else if tappedBlock.object.image == UIImage(named: "block_orange.png")! {
            tappedBlock.color = 3
        }
        else if tappedBlock.object.image == UIImage(named: "block_green.png")! {
            tappedBlock.color = 4
        }
        else if tappedBlock.object.image == UIImage(named: "block_blue.png")! {
            tappedBlock.color = 5
        }
        else if tappedBlock.object.image == UIImage(named: "block_purple.png")! {
            tappedBlock.color = 6
        }
        else if tappedBlock.object.image == UIImage(named: "block_pink.png")! {
            tappedBlock.color = 7
        }
        else if tappedBlock.object.image == UIImage(named: "block_white.png")! {
            tappedBlock.color = 8
        }
        
        // The Block Tapped is the Target
        if tappedBlock.color == target {
            // Play Success Sound
            if lives > 0 {
                updateScore(blockTapped: tappedBlock, scoreMultiplier: 2)
            }
        }
        // The Block tapped is not the Target
        else {
            // Play Failure Sound
            if lives > 0 {
                updateScore(blockTapped: tappedBlock, scoreMultiplier: -1)
            }
            lifeLost(blockTapped: tappedBlock)
            
        }
        // Reset the Block with New Attributes
        resetBlock(blockTapped: tappedBlock)
    }
    
    // Losing a life
    func lifeLost(blockTapped: block) {
        switch blockTapped.color {
            case 1:
                redLifeImage.isHidden = false
                if redLife == 0 {
                    lives -= 1
                }
                redLife = 1
            case 2:
                yellowLifeImage.isHidden = false
                if yellowLife == 0 {
                    lives -= 1
                }
                yellowLife = 1
            case 3:
                orangeLifeImage.isHidden = false
                if orangeLife == 0 {
                    lives -= 1
                }
                orangeLife = 1
            case 4:
                greenLifeImage.isHidden = false
                if greenLife == 0 {
                    lives -= 1
                }
                greenLife = 1
            case 5:
                blueLifeImage.isHidden = false
                if blueLife == 0 {
                    lives -= 1
                }
                blueLife = 1
            case 6:
                purpleLifeImage.isHidden = false
                if purpleLife == 0 {
                    lives -= 1
                }
                purpleLife = 1
            case 7:
                pinkLifeImage.isHidden = false
                if pinkLife == 0 {
                    lives -= 1
                }
                pinkLife = 1
            case 8:
                whiteLifeImage.isHidden = false
                if whiteLife == 0 {
                    lives -= 1
                }
                whiteLife = 1
            default:
                break
        }
        if lives == 0 {
            gameOver()
        }
        if lives == 1 {
            lives -= 1
        }
    }
    
    // Player Loses the Game
    func gameOver() {
        //PLAY GAME OVER SOUND
        
        // Stopping Timers
        updateBlockTimer.invalidate()
        updateTargetTimer.invalidate()
        
        // Reveal Game Over Menu
        gameOverImageBackground.isHidden = false
        gameOverLabel.isHidden = false
        gameOverButton.isHidden = false
        
        // Updating Highscores
        updateScores()
        
    }
    
    // Updates Highscores
    func updateScores() {
        let userDefaults = Foundation.UserDefaults.standard
        
        // There is a new Highscore
        if score > HighscoreTEN {
            labelNewHighScore.isHidden = false
        }
        
        // Moving Scores Down
        if score > HighscoreONE {
            userDefaults.set(HighscoreNINE, forKey: "HighscoreTEN")
            userDefaults.set(HighscoreEIGHT, forKey: "HighscoreNINE")
            userDefaults.set(HighscoreSEVEN, forKey: "HighscoreEIGHT")
            userDefaults.set(HighscoreSIX, forKey: "HighscoreSEVEN")
            userDefaults.set(HighscoreFIVE, forKey: "HighscoreSIX")
            userDefaults.set(HighscoreFOUR, forKey: "HighscoreFIVE")
            userDefaults.set(HighscoreTHREE, forKey: "HighscoreFOUR")
            userDefaults.set(HighscoreTWO, forKey: "HighscoreTHREE")
            userDefaults.set(HighscoreONE, forKey: "HighscoreTWO")
            userDefaults.set(score, forKey: "HighscoreONE")
            
            userDefaults.set(HighlevelNINE, forKey: "HighlevelTEN")
            userDefaults.set(HighlevelEIGHT, forKey: "HighlevelNINE")
            userDefaults.set(HighlevelSEVEN, forKey: "HighlevelEIGHT")
            userDefaults.set(HighlevelSIX, forKey: "HighlevelSEVEN")
            userDefaults.set(HighlevelFIVE, forKey: "HighlevelSIX")
            userDefaults.set(HighlevelFOUR, forKey: "HighlevelFIVE")
            userDefaults.set(HighlevelTHREE, forKey: "HighlevelFOUR")
            userDefaults.set(HighlevelTWO, forKey: "HighlevelTHREE")
            userDefaults.set(HighlevelONE, forKey: "HighlevelTWO")
            userDefaults.set(level, forKey: "HighlevelONE")
        }
        else if score > HighscoreTWO {
            userDefaults.set(HighscoreNINE, forKey: "HighscoreTEN")
            userDefaults.set(HighscoreEIGHT, forKey: "HighscoreNINE")
            userDefaults.set(HighscoreSEVEN, forKey: "HighscoreEIGHT")
            userDefaults.set(HighscoreSIX, forKey: "HighscoreSEVEN")
            userDefaults.set(HighscoreFIVE, forKey: "HighscoreSIX")
            userDefaults.set(HighscoreFOUR, forKey: "HighscoreFIVE")
            userDefaults.set(HighscoreTHREE, forKey: "HighscoreFOUR")
            userDefaults.set(HighscoreTWO, forKey: "HighscoreTHREE")
            userDefaults.set(score, forKey: "HighscoreTWO")
            
            userDefaults.set(HighlevelNINE, forKey: "HighlevelTEN")
            userDefaults.set(HighlevelEIGHT, forKey: "HighlevelNINE")
            userDefaults.set(HighlevelSEVEN, forKey: "HighlevelEIGHT")
            userDefaults.set(HighlevelSIX, forKey: "HighlevelSEVEN")
            userDefaults.set(HighlevelFIVE, forKey: "HighlevelSIX")
            userDefaults.set(HighlevelFOUR, forKey: "HighlevelFIVE")
            userDefaults.set(HighlevelTHREE, forKey: "HighlevelFOUR")
            userDefaults.set(HighlevelTWO, forKey: "HighlevelTHREE")
            userDefaults.set(level, forKey: "HighlevelTWO")
        }
        else if score > HighscoreTHREE {
            userDefaults.set(HighscoreNINE, forKey: "HighscoreTEN")
            userDefaults.set(HighscoreEIGHT, forKey: "HighscoreNINE")
            userDefaults.set(HighscoreSEVEN, forKey: "HighscoreEIGHT")
            userDefaults.set(HighscoreSIX, forKey: "HighscoreSEVEN")
            userDefaults.set(HighscoreFIVE, forKey: "HighscoreSIX")
            userDefaults.set(HighscoreFOUR, forKey: "HighscoreFIVE")
            userDefaults.set(HighscoreTHREE, forKey: "HighscoreFOUR")
            userDefaults.set(score, forKey: "HighscoreTHREE")
            
            userDefaults.set(HighlevelNINE, forKey: "HighlevelTEN")
            userDefaults.set(HighlevelEIGHT, forKey: "HighlevelNINE")
            userDefaults.set(HighlevelSEVEN, forKey: "HighlevelEIGHT")
            userDefaults.set(HighlevelSIX, forKey: "HighlevelSEVEN")
            userDefaults.set(HighlevelFIVE, forKey: "HighlevelSIX")
            userDefaults.set(HighlevelFOUR, forKey: "HighlevelFIVE")
            userDefaults.set(HighlevelTHREE, forKey: "HighlevelFOUR")
            userDefaults.set(level, forKey: "HighlevelTHREE")
        }
        else if score > HighscoreFOUR {
            userDefaults.set(HighscoreNINE, forKey: "HighscoreTEN")
            userDefaults.set(HighscoreEIGHT, forKey: "HighscoreNINE")
            userDefaults.set(HighscoreSEVEN, forKey: "HighscoreEIGHT")
            userDefaults.set(HighscoreSIX, forKey: "HighscoreSEVEN")
            userDefaults.set(HighscoreFIVE, forKey: "HighscoreSIX")
            userDefaults.set(HighscoreFOUR, forKey: "HighscoreFIVE")
            userDefaults.set(score, forKey: "HighscoreFOUR")
            
            userDefaults.set(HighlevelNINE, forKey: "HighlevelTEN")
            userDefaults.set(HighlevelEIGHT, forKey: "HighlevelNINE")
            userDefaults.set(HighlevelSEVEN, forKey: "HighlevelEIGHT")
            userDefaults.set(HighlevelSIX, forKey: "HighlevelSEVEN")
            userDefaults.set(HighlevelFIVE, forKey: "HighlevelSIX")
            userDefaults.set(HighlevelFOUR, forKey: "HighlevelFIVE")
            userDefaults.set(level, forKey: "HighlevelFOUR")
        }
        else if score > HighscoreFIVE {
            userDefaults.set(HighscoreNINE, forKey: "HighscoreTEN")
            userDefaults.set(HighscoreEIGHT, forKey: "HighscoreNINE")
            userDefaults.set(HighscoreSEVEN, forKey: "HighscoreEIGHT")
            userDefaults.set(HighscoreSIX, forKey: "HighscoreSEVEN")
            userDefaults.set(HighscoreFIVE, forKey: "HighscoreSIX")
            userDefaults.set(score, forKey: "HighscoreFIVE")
            
            userDefaults.set(HighlevelNINE, forKey: "HighlevelTEN")
            userDefaults.set(HighlevelEIGHT, forKey: "HighlevelNINE")
            userDefaults.set(HighlevelSEVEN, forKey: "HighlevelEIGHT")
            userDefaults.set(HighlevelSIX, forKey: "HighlevelSEVEN")
            userDefaults.set(HighlevelFIVE, forKey: "HighlevelSIX")
            userDefaults.set(level, forKey: "HighlevelFIVE")
        }
        else if score > HighscoreSIX {
            userDefaults.set(HighscoreNINE, forKey: "HighscoreTEN")
            userDefaults.set(HighscoreEIGHT, forKey: "HighscoreNINE")
            userDefaults.set(HighscoreSEVEN, forKey: "HighscoreEIGHT")
            userDefaults.set(HighscoreSIX, forKey: "HighscoreSEVEN")
            userDefaults.set(score, forKey: "HighscoreSIX")
            
            userDefaults.set(HighlevelNINE, forKey: "HighlevelTEN")
            userDefaults.set(HighlevelEIGHT, forKey: "HighlevelNINE")
            userDefaults.set(HighlevelSEVEN, forKey: "HighlevelEIGHT")
            userDefaults.set(HighlevelSIX, forKey: "HighlevelSEVEN")
            userDefaults.set(level, forKey: "HighlevelSIX")
        }
        else if score > HighscoreSEVEN {
            userDefaults.set(HighscoreNINE, forKey: "HighscoreTEN")
            userDefaults.set(HighscoreEIGHT, forKey: "HighscoreNINE")
            userDefaults.set(HighscoreSEVEN, forKey: "HighscoreEIGHT")
            userDefaults.set(score, forKey: "HighscoreSEVEN")
            
            userDefaults.set(HighlevelNINE, forKey: "HighlevelTEN")
            userDefaults.set(HighlevelEIGHT, forKey: "HighlevelNINE")
            userDefaults.set(HighlevelSEVEN, forKey: "HighlevelEIGHT")
            userDefaults.set(level, forKey: "HighlevelSEVEN")
        }
        else if score > HighscoreEIGHT {
            userDefaults.set(HighscoreNINE, forKey: "HighscoreTEN")
            userDefaults.set(HighscoreEIGHT, forKey: "HighscoreNINE")
            userDefaults.set(score, forKey: "HighscoreEIGHT")
            
            userDefaults.set(HighlevelNINE, forKey: "HighlevelTEN")
            userDefaults.set(HighlevelEIGHT, forKey: "HighlevelNINE")
            userDefaults.set(level, forKey: "HighlevelEIGHT")
        }
        else if score > HighscoreNINE {
            userDefaults.set(HighscoreNINE, forKey: "HighscoreTEN")
            userDefaults.set(score, forKey: "HighscoreNINE")
            
            userDefaults.set(HighlevelNINE, forKey: "HighlevelTEN")
            userDefaults.set(level, forKey: "HighlevelNINE")
        }
        else if score > HighscoreTEN {
            userDefaults.set(score, forKey: "HighscoreTEN")
            userDefaults.set(level, forKey: "HighlevelTEN")
        }
    }
}
