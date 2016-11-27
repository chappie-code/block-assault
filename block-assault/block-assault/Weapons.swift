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
    var playerTouchPoint:CGPoint?;
    var position:CGPoint?;
    
    
    //Time Variables
    var lastMainWeaponFireTime:CFTimeInterval;
    
    init(shooterType:String, parentScene:SKScene)
    {
        
        self.parentScene = parentScene;
        self.shooterType = shooterType;
        self.lastMainWeaponFireTime = 0;
        
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
    
    func think(_ currentTime:CFTimeInterval)
    {
        
        if(self.playerTouchPoint != nil)
        {
            
            if((currentTime - lastMainWeaponFireTime) >= 0.2)
            {
                lastMainWeaponFireTime = currentTime;
                self.fireMainWeapon();
            }
        }
        
        
        
        
    }
    
    func fireMainWeapon()
    {
        //find a solution for multi weapons
        if(self.playerTouchPoint != nil && self.position != nil)
        {
            self.fireBlockTo(location: self.playerTouchPoint!);
        }
    }
    
    func fireBlockTo(location:CGPoint)
    {
        let shapeObject = SKShapeNode(rectOf: CGSize(width: 2, height: 2));
        
        shapeObject.strokeColor = SKColor.white;
        
        shapeObject.fillColor = SKColor.orange;
        shapeObject.position = self.position!
        
        
        
        shapeObject.physicsBody = SKPhysicsBody(rectangleOf: CGSize( width: 2, height: 2))
        shapeObject.physicsBody?.isDynamic = true
        shapeObject.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
        shapeObject.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
        shapeObject.physicsBody?.collisionBitMask = PhysicsCategory.None
        shapeObject.physicsBody?.usesPreciseCollisionDetection = true
        
        
        
        // 3) determin offset of location to projectile
        let offset = location - shapeObject.position;
        
        
        self.parentScene.addChild(shapeObject);
        
        // 6) get the direction of where to shoot
        let direction = offset.normalized();
        
        // 7 Make it shoot far enough to be guaranteed off screen
        let shootAmount = direction * 1000;
        
        // 8) Add the shot amount to the current position
        let realDest = shootAmount + shapeObject.position;
        
        // 9) Create the action
        let actionMove = SKAction.move(to: realDest,duration: 2.0);
        let actionMoveDone = SKAction.removeFromParent();
        shapeObject.run(SKAction.sequence([actionMove,actionMoveDone]));
    }
    
    func playerTouched(point:CGPoint)
    {
        self.playerTouchPoint = point;
        
        
    }
    
    func playerStoppedTouch()
    {
        self.playerTouchPoint = nil;
    }
    
    
}
