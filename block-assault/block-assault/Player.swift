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
    var position:CGPoint?;
    var healthMax:CGFloat = 100.0;
    var score:Int = 0;
    var parentScene:SKScene;
    //var lightingNode:SKLightNode;
    
    
    init()
    {
        
        // spriteName = "player";
        
        spriteObject = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 4, height: 4));
        spriteObject.lightingBitMask = 1;
        spriteObject.physicsBody = SKPhysicsBody(rectangleOf: spriteObject.size);
        spriteObject.physicsBody?.isDynamic = true;
        spriteObject.physicsBody?.categoryBitMask = PhysicsCategory.Player
        spriteObject.physicsBody?.contactTestBitMask = PhysicsCategory.None
        spriteObject.physicsBody?.collisionBitMask = PhysicsCategory.None
        spriteObject.physicsBody?.usesPreciseCollisionDetection = true;
        
        /*
        shapeObject = SKShapeNode(rect: CGRect(x: -5, y: 0, width: 10, height: 10));
        
        shapeObject.strokeColor = SKColor.white
        shapeObject.glowWidth = 2.0
        shapeObject.fillColor = SKColor.orange
        
        shapeObject.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 10));
        shapeObject.physicsBody?.isDynamic = true;
        shapeObject.physicsBody?.categoryBitMask = PhysicsCategory.Player
        shapeObject.physicsBody?.contactTestBitMask = PhysicsCategory.None
        shapeObject.physicsBody?.collisionBitMask = PhysicsCategory.None
        shapeObject.physicsBody?.usesPreciseCollisionDetection = true;
        
        
        */
        size = spriteObject.size;
        
        
        parentScene = SKScene();
        
        
        
    }
    
    func drawObject()
    {
        
        
        
        
//        self.parentScene.addChild(self.spriteObject);
    

    }
    
   
    
    func setParentScene(scene:SKScene)
    {
        self.parentScene = scene;
        spriteObject.position = CGPoint(x: parentScene.size.width / 2 , y: parentScene.size.height * 0.9);
        
        
    }
    
    func swordAnimation()
    {
        let shape = SKShapeNode()
        shape.path = UIBezierPath(roundedRect: CGRect(x: -5, y: 0, width: 10, height: 50), cornerRadius: 2).cgPath
        shape.position = CGPoint(x: self.getPosition().x,y: self.getPosition().y - 100) ;
        
        
        shape.strokeColor = UIColor(colorLiteralRed: 0.7, green: 0.7, blue: 0.9, alpha: 0.5)
    
        shape.glowWidth = 2;
        
        
        shape.lineWidth = 2;
        
        
        
        let actionMove = SKAction.move(to: CGPoint(x: self.getPosition().x, y: self.getPosition().y + 30), duration: 1)
        let actionMoveDone = SKAction.removeFromParent()
        
        
        self.parentScene.addChild(shape)
        
        shape.run(SKAction.sequence([ actionMove, actionMoveDone]));
        
        
        
        
        
        

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
        self.position = myPosition;
        self.spriteObject.position = myPosition;
    }
    
    func getPosition() -> CGPoint {
        return self.position!;
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
