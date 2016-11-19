//
//  Monster.swift
//  block-assault
//
//  Created by Edward McIntosh on 2016-10-01.
//  Copyright © 2016 Edward McIntosh. All rights reserved.
//

import Foundation
import SpriteKit



class Monster : SKSpriteNode{
    
    
    //var spriteObject:SKSpriteNode;
    var health:Int;
    var lastKnownPlayerPosition:CGPoint?;
    var enableLighting:Bool;
    var velocity:CGFloat;
    
    init()
    {
        self.health = 5;
        self.velocity = 15;
        
        let texture = SKTexture(noiseWithSmoothness: 0.9, size: CGSize(width: 20, height: 20), grayscale: true);
        enableLighting = false;
        
        
        super.init(texture: texture, color: UIColor.red, size: CGSize(width: 20, height: 20));
        
        self.colorBlendFactor = 0.5;
       

        self.physicsBody = SKPhysicsBody(rectangleOf: self.size);
        self.physicsBody?.isDynamic = true;
        self.physicsBody?.categoryBitMask = PhysicsCategory.Monster
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
        self.physicsBody?.collisionBitMask = PhysicsCategory.None;
        self.physicsBody?.usesPreciseCollisionDetection = true;
        
        
        
        if(enableLighting)
        {
            let light = SKLightNode();
            light.position = CGPoint(x: 0,y: 0)
            light.falloff = 0.1;
            light.lightColor = UIColor.red;
            light.isEnabled = true;
            self.addChild(light);
        }
        
    }
    
    func distanceBetween(pointOne:CGPoint, pointTwo:CGPoint) -> CGFloat
    {
        let xDist:CGFloat = (pointTwo.x - pointOne.x);
        let yDist:CGFloat = (pointTwo.y - pointOne.y);
        let distance:CGFloat = sqrt((xDist * xDist) + (yDist * yDist));
        return distance;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getTravelTimeFor(distance:CGFloat) -> CGFloat
    {
        return distance / self.velocity;
    }
    
    
    
    func attack(playerPosition:CGPoint)
    {
        // Determine speed of the monster
        
        
        
        let distance = self.distanceBetween(pointOne: playerPosition, pointTwo: self.position)
        
        let actualDuration = self.getTravelTimeFor(distance: distance);
        let roationAmount = random(min:CGFloat(0), max:CGFloat(2.0));
        
        let rotateAction = SKAction.rotate(byAngle: roationAmount, duration: 0);
        let actionMove = SKAction.move(to: playerPosition, duration: TimeInterval(actualDuration))
        
        let actionMoveDone = SKAction.removeFromParent()
        
        
        self.run(SKAction.sequence([rotateAction, actionMove, actionMoveDone]));
        
    }
    
    func reduceHealth(by:Int = 1)
    {
        self.health = self.health - 1;
        self.velocity = self.velocity - 3;
        
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    
}
