//
//  block.swift
//  Colors
//
//  Created by Dylan Rothfeld on 1/28/17.
//  Copyright © 2017 Rothfeld. All rights reserved.
//

import Foundation
import UIKit

class block {
    
    // Device Values TESTING
    let screenWidth  = UIScreen.main.fixedCoordinateSpace.bounds.width
    let screenHeight = UIScreen.main.fixedCoordinateSpace.bounds.height
    
    // Fields
    var speed: Double
    var color: Int
    var size: Int
    var Xpos: Int
    var Ypos: Int
    var blockImage: UIImage
    var object: UIImageView
    
    // Construct
    init() {
        self.speed = Double(arc4random_uniform(3) + 2)
        self.color = Int(arc4random_uniform(8) + 1)
        self.size = Int(arc4random_uniform(50) + 10)
        self.Xpos = Int(arc4random_uniform(UInt32(Int(screenWidth)) - 25) + 10)
        self.Ypos = Int(arc4random_uniform(UInt32(Int(screenHeight))) + 0)
        
        
        switch self.color {
            
            case 1:
                self.blockImage = UIImage(named: "block_red.png")!
            
            case 2:
                self.blockImage = UIImage(named: "block_yellow.png")!
            
            case 3:
                self.blockImage = UIImage(named: "block_orange.png")!
            
            case 4:
                self.blockImage = UIImage(named: "block_green.png")!
            
            case 5:
                self.blockImage = UIImage(named: "block_blue.png")!
            
            case 6:
                self.blockImage = UIImage(named: "block_purple.png")!
            
            case 7:
                self.blockImage = UIImage(named: "block_pink.png")!
            
            case 8:
                self.blockImage = UIImage(named: "block_white.png")!
            
            default:
                self.blockImage = UIImage(named: "block_white.png")!
        }
        
        self.object = UIImageView(frame: CGRect(x: CGFloat(Xpos), y: CGFloat(Ypos), width: CGFloat(size + color), height: CGFloat(size + color)))
        
        self.object.image = self.blockImage
        
    }
    
    
}
