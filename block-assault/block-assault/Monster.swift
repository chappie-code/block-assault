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
    var lastKnownPlayerPosition:CGPoint;
    var enableLighting:Bool;
    var velocity:CGVector;
    var velocityAmount:CGFloat;
    
    var angle:CGFloat;
    
    //Time variables
    var timeElapsedSinceLastThought:CFTimeInterval;
    var lastThought:CFTimeInterval;
    var lastAttachUpdate:CFTimeInterval;
    
    
    init()
    {
        self.health = 5;
        
        self.timeElapsedSinceLastThought = 0;
        self.lastThought = 0;
        self.lastAttachUpdate = 0;
        self.lastKnownPlayerPosition = CGPoint(x: 0, y: 0);
        self.angle = 0;
        
        let texture = SKTexture(noiseWithSmoothness: 0.9, size: CGSize(width: 20, height: 20), grayscale: true);
        enableLighting = false;
        
        self.velocity = CGVector(dx: 0, dy: 0);
        self.velocityAmount = 15.0;
        super.init(texture: texture, color: UIColor.red, size: CGSize(width: 20, height: 20));
        
        self.colorBlendFactor = 0.5;
       
        

        self.physicsBody = SKPhysicsBody(rectangleOf: self.size);
        self.physicsBody?.isDynamic = true;
        self.physicsBody?.affectedByGravity = false;
        self.physicsBody?.categoryBitMask = PhysicsCategory.Monster
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile | PhysicsCategory.Psy;
        self.physicsBody?.collisionBitMask = PhysicsCategory.None;
        self.physicsBody?.usesPreciseCollisionDetection = true;
        
        
        
        if(enableLighting)
        {
            let light = SKLightNode();
            light.position = CGPoint(x: 0,y: 0)
            light.falloff = 0.999;
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
        return 1.0;
    }
    
    
    
    func attack(playerPosition:CGPoint)
    {
        

        let path:CGMutablePath = CGMutablePath();
        
        path.move(to: self.position);
        path.addLine(to: playerPosition);
        let myPath:CGPath = path.copy()!;
        
        
        let actionMove:SKAction = SKAction.follow(myPath, asOffset: false, orientToPath: true, speed: velocityAmount);
        
        
        self.run(actionMove);
        
        
        
        
        //let distance = self.distanceBetween(pointOne: playerPosition, pointTwo: self.position)
        
        //let actualDuration = self.getTravelTimeFor(distance: distance);
        //let rotationAmount = self.getRotationTo(point: playerPosition);
        
        //print(actualDuration);
        //print(lastKnownPlayerPosition);
        
        //let actionRotate = SKAction.rotate(byAngle: rotationAmount, duration: 0.5)
        //let actionMove = SKAction.move(to: playerPosition, duration: TimeInterval(actualDuration))
        
        //let actionMoveDone = SKAction.removeFromParent()
        
        //self.removeAllActions();
        //self.run(SKAction.sequence([actionMove, actionMoveDone]), withKey: "Attack Player");
        
        //self.velocity = CGVector(dx:10,dy:1);
        //self.physicsBody?.velocity = self.velocity
        
    }
    
    func think(_ currentTime: CFTimeInterval)
    {
        
        
        self.timeElapsedSinceLastThought = currentTime - self.lastThought ;
        self.lastThought = currentTime;
        
        let TimeSinceLastAttachUpdate:CFTimeInterval = currentTime - lastAttachUpdate;
        
        
        
        if(TimeSinceLastAttachUpdate > 10)
        {
            self.lastAttachUpdate = currentTime;
            self.attack(playerPosition: lastKnownPlayerPosition);
        }
        
        
    }
    
    func updatePlayer(position:CGPoint)
    {
        self.lastKnownPlayerPosition = position;
    }
    
    func reduceHealth(by:Int = 1)
    {
        self.health = self.health - 1;
        
        
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func getRotationTo(point:CGPoint) -> CGFloat
    {
        let positionInScene:CGPoint = point;
        
        let deltaX:CGFloat  = positionInScene.x - self.position.x;
        let deltaY:CGFloat  = positionInScene.y - self.position.y;
        
        let angle:CGFloat = CGFloat(atan2f(Float(deltaY), Float(deltaX)));
        
        return CGFloat(GLKMathDegreesToRadians(Float(angle)));
    }
}
