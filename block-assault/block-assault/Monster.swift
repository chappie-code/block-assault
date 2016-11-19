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
    
    
    var spriteObject:SKSpriteNode;
    var position:CGPoint?;
    var size:CGSize;
    var health:Int;
    var lastKnownPlayerPosition:CGPoint?;
    
    init()
    {
        spriteObject = SKSpriteNode(color: UIColor.red, size: CGSize(width: 20, height: 20));
        
        spriteObject.lightingBitMask = 1;

        spriteObject.physicsBody = SKPhysicsBody(rectangleOf: spriteObject.size);
        spriteObject.physicsBody?.isDynamic = true;
        spriteObject.physicsBody?.categoryBitMask = PhysicsCategory.Monster
        spriteObject.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
        spriteObject.physicsBody?.collisionBitMask = PhysicsCategory.None;
        spriteObject.physicsBody?.usesPreciseCollisionDetection = true;
        spriteObject.lightingBitMask = 1;
        
        size = spriteObject.size;
        
        health = 5;
        
    }
    
    
    func setPosition(myPosition:CGPoint)
    {
        self.position = myPosition;
        self.spriteObject.position = myPosition;
        
        let light = SKLightNode();
        light.position = CGPoint(x: 0,y: 0)
        light.falloff = 0.1;
        light.lightColor = UIColor.red;
        light.isEnabled = true;
        spriteObject.addChild(light);
    }
    
    func attack(playerPosition:CGPoint)
    {
        // Determine speed of the monster
        
        let actualDuration = random(min: CGFloat(4.0), max: CGFloat(10.0))
        let roationAmount = random(min:CGFloat(0), max:CGFloat(2.0));
        
        let rotateAction = SKAction.rotate(byAngle: roationAmount, duration: 0);
        let actionMove = SKAction.move(to: playerPosition, duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        
        
        self.spriteObject.run(SKAction.sequence([rotateAction, actionMove, actionMoveDone]));
        
    }
    
    func monsterHit(by:Int = 1)
    {
        self.health = self.health - 1;
        
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    
}
