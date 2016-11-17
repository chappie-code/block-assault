//
//  Weapons.swift
//  block-assault
//
//  Created by Edward McIntosh on 11/17/16.
//  Copyright © 2016 Edward McIntosh. All rights reserved.
//

import Foundation
import SpriteKit

class Weapons {
    var shooterType:String;
    var parentScene:SKScene;
    
    init(shooterType:String, parentScene:SKScene)
    {
        self.parentScene = parentScene;
        self.shooterType = shooterType;
    }
    
    func swordAnimation(fromPosition:CGPoint, pointingAt:CGFloat = 0.0)
    {
        let shape = SKShapeNode()
        shape.path = UIBezierPath(roundedRect: CGRect(x: -5, y: 0, width: 10, height: 50), cornerRadius: 2).cgPath
        shape.position = CGPoint(x: fromPosition.x,y: fromPosition.y - 100) ;
        
        
        shape.strokeColor = UIColor(colorLiteralRed: 0.7, green: 0.7, blue: 0.9, alpha: 0.9)
        
        shape.glowWidth = 2;
        
        
        shape.lineWidth = 2;
        
        let randomNum:CGFloat = CGFloat(arc4random_uniform(100)) // range is 0 to 9
        
        let rotateMove = SKAction.rotate(byAngle: (pointingAt + CGFloat(randomNum)), duration: 1);
        let actionMove = SKAction.move(to: CGPoint(x: fromPosition.x, y: fromPosition.y + 30), duration: 1)
        let actionMoveDone = SKAction.removeFromParent()
        
        
        self.parentScene.addChild(shape)
        
        shape.run(SKAction.sequence([rotateMove, actionMove, actionMoveDone]));
        
        
        
        
        
        
        
    }
    
    
}
