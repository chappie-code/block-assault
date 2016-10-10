//
//  Monster.swift
//  block-assault
//
//  Created by Edward McIntosh on 2016-10-01.
//  Copyright © 2016 Edward McIntosh. All rights reserved.
//

import Foundation
import SpriteKit


class Monster{
    
    var spriteName:String;
    var spriteObject:SKSpriteNode;
    var position:CGPoint?;
    var size:CGSize;
    
    init()
    {
        spriteName = "monster";
        spriteObject = SKSpriteNode(imageNamed: spriteName);
        spriteObject.physicsBody = SKPhysicsBody(rectangleOfSize: spriteObject.size);
        spriteObject.physicsBody?.dynamic = true;
        spriteObject.physicsBody?.categoryBitMask = PhysicsCategory.Monster
        spriteObject.physicsBody?.contactTestBitMask = PhysicsCategory.Player | PhysicsCategory.Projectile
        spriteObject.physicsBody?.collisionBitMask = PhysicsCategory.None;
        spriteObject.physicsBody?.usesPreciseCollisionDetection = true;
        
        size = spriteObject.size;
        
    }
    
    
    func setPosition(myPosition:CGPoint)
    {
        self.position = myPosition;
        self.spriteObject.position = myPosition;
    }
    
    func attack(playerPosition:CGPoint)
    {
        // Determine speed of the monster
        
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        let roationAmount = random(min:CGFloat(0), max:CGFloat(2.0));
        
        let rotateAction = SKAction.rotateByAngle(roationAmount, duration: 0);
        let actionMove = SKAction.moveTo(playerPosition, duration: NSTimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        
        
        self.spriteObject.runAction(SKAction.sequence([rotateAction, actionMove, actionMoveDone]));
        
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    
}