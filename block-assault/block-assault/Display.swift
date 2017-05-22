//
//  Display.swift
//  block-assault
//
//  Created by Edward McIntosh on 2016-11-10.
//  Copyright © 2016 Edward McIntosh. All rights reserved.
//

import Foundation
import SpriteKit


class Display {
    
    var healthLabel:SKLabelNode;
    var scoreLabel:SKLabelNode;
    var changeWeaponButton:SKSpriteNode;

    

    init(size: CGSize)
    {
        
        let player = Player();
        
        self.healthLabel = SKLabelNode(fontNamed: "Helvetica-BoldOblique")
        let c:String = String(format:"%.1f", player.healthMax);
        self.healthLabel.text = c;
        self.healthLabel.fontSize = 40;
        healthLabel.fontColor = SKColor.white;
        healthLabel.position = CGPoint(x: 50, y: 0);
        
        self.scoreLabel = SKLabelNode(fontNamed: "Helvetica-BoldOblique")
        let c2:String = String(format:"%d", 0);
        scoreLabel.text = c2;
        scoreLabel.fontSize = 40;
        scoreLabel.fontColor = SKColor.white;
        scoreLabel.position = CGPoint(x: 50, y: 50);
        
        
        self.changeWeaponButton = SKSpriteNode(color: SKColor.red, size: CGSize(width: 100, height: 44))
        self.changeWeaponButton.position = CGPoint(x: size.width - 110, y: size.height - 54);
        
        

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func get() -> SKLabelNode
    {
        return self.healthLabel;
        
    }
    
    func updateHealth(health:Double)
    {
        healthLabel.text = String(format:"%.1f", health);
    }
    
    func updateScore(score:Int)
    {
        scoreLabel.text = String(score);
    }
}

