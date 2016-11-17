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
    var health = 100.0;
     var spriteObject:SKSpriteNode;
    //var shapeObject:SKShapeNode;
    // var spriteName:String;
    var size:CGSize;
    var healthMax:CGFloat = 100.0;
    var score:Int = 0;
    var parentScene:SKScene;
    //var lightingNode:SKLightNode;
    var weapon:Weapons;
    
    
    init()
    {
        
        // spriteName = "player";
        
        spriteObject = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 20, height: 20));
        
        spriteObject.lightingBitMask = 1;
        
        spriteObject.physicsBody = SKPhysicsBody(rectangleOf: spriteObject.size);
        spriteObject.physicsBody?.isDynamic = true;
        spriteObject.physicsBody?.categoryBitMask = PhysicsCategory.Player
        spriteObject.physicsBody?.contactTestBitMask = PhysicsCategory.None
        spriteObject.physicsBody?.collisionBitMask = PhysicsCategory.None
        spriteObject.physicsBody?.usesPreciseCollisionDetection = false;
        
        size = spriteObject.size;
        
        
        parentScene = SKScene();
        weapon = Weapons(shooterType: "player", parentScene: self.parentScene);
        
        
        
    }
    
    
    func setParentScene(scene:SKScene)
    {
        // set parents
        self.parentScene = scene;
        self.weapon.parentScene = scene;
        
        
        
        spriteObject.position = CGPoint(x: parentScene.size.width / 2 , y: parentScene.size.height * 0.9);
        
        let light = SKLightNode();
        light.position = CGPoint(x: 0,y: 0)
        light.falloff = 0.3;
        light.isEnabled = true;
        light.lightColor = UIColor.blue;
        spriteObject.addChild(light);
    }
    
    func swordSwing()
    {
        weapon.swordAnimation(fromPosition: self.getPosition())

    }
    
    func setHeath(valueTo:Double)
    {
        self.health = valueTo;
        
    }
    
    func getHealth() -> Double
    {
        return self.health;
    }
    
    func removeHealth(by:Double)
    {
        self.health -= by;
        
    }
    
    func setPosition(myPosition:CGPoint)
    {
        self.spriteObject.position = myPosition;
    }
    
    func getPosition() -> CGPoint {
        return self.spriteObject.position;
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func updateScore(increase by:Int)
    {
        self.score += by;
    }
    func getScore() -> Int
    {
        return self.score;
    }

}
