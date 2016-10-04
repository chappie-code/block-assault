//
//  Player.swift
//  block-assault
//
//  Created by Edward McIntosh on 2016-10-03.
//  Copyright © 2016 Edward McIntosh. All rights reserved.
//

import Foundation
import SpriteKit


class Player {
    var health = 0.0;
    var spriteObject:SKSpriteNode;
    var spriteName:String;
    var size:CGSize;
    var position:CGPoint?;
    
    
    init()
    {
        spriteName = "player";
        spriteObject = SKSpriteNode(imageNamed: spriteName);
        spriteObject.physicsBody = SKPhysicsBody(rectangleOfSize: spriteObject.size);
        spriteObject.physicsBody?.dynamic = true;
        spriteObject.physicsBody?.categoryBitMask = PhysicsCategory.None
        spriteObject.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
        spriteObject.physicsBody?.collisionBitMask = PhysicsCategory.None
        spriteObject.physicsBody?.usesPreciseCollisionDetection = true;
        
        size = spriteObject.size;
        
    }
    
    func setHeath(valueTo:Double)
    {
        self.health = valueTo;
        
    }
    
    func removeHealth(by:Double)
    {
        self.health -= by;
        
    }
    
    func setPosition(myPosition:CGPoint)
    {
        self.position = myPosition;
        self.spriteObject.position = myPosition;
    }
    
    func getPosition() -> CGPoint {
        return self.position!;
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }

}