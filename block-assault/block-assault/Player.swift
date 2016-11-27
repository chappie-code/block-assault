//
//  Player.swift
//  block-assault
//
//  Created by Edward McIntosh on 2016-10-03.
//  Copyright © 2016 Edward McIntosh. All rights reserved.
//

import Foundation
import SpriteKit


class Player :SKSpriteNode {
    var health = 100.0;
     
    //var shapeObject:SKShapeNode;
    // var spriteName:String;
    
    var healthMax:CGFloat = 100.0;
    var score:Int = 0;
    var parentScene:SKScene;
    
    var weapon:Weapons;
    var enableLighting:Bool;
    
    
    init()
    {
        
        // spriteName = "player";
        
       
        enableLighting = false;
        
        
        
        parentScene = SKScene();
        weapon = Weapons(shooterType: "player", parentScene: self.parentScene);
        
        let texture = SKTexture(noiseWithSmoothness: 0.9, size: CGSize(width: 20, height: 20), grayscale: true);
        enableLighting = false;
        
        super.init(texture: texture, color: UIColor.blue, size: CGSize(width: 20, height: 20));
        self.colorBlendFactor = 0.5;
        self.lightingBitMask = 1;
        
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size);
        self.physicsBody?.isDynamic = true;
        self.physicsBody?.categoryBitMask = PhysicsCategory.Player
        self.physicsBody?.contactTestBitMask = PhysicsCategory.None
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
        self.physicsBody?.usesPreciseCollisionDetection = false;
        
        
        
        
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setParentScene(scene:SKScene)
    {
        // set parents
        self.parentScene = scene;
        self.weapon.parentScene = scene;
        
        self.position = CGPoint(x: parentScene.size.width / 2 , y: parentScene.size.height * 0.9);
        self.weapon.position = self.position;
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
    
    func moveLeft(by:CGFloat = 30)
    {
        let moveAction = SKAction.moveTo(x: self.getPosition().x - by, duration: 0.2);
        self.run(moveAction);
        
        
    }
    func moveRight(by:CGFloat = 30)
    {
        let moveAction = SKAction.moveTo(x: self.getPosition().x + by, duration: 0.2);
        
        self.run(moveAction);
        
        
    }
    
    func moveUp(by:CGFloat = 30)
    {
        let moveAction = SKAction.moveTo(y: self.getPosition().y + by , duration: 0.2);
        
        self.run(moveAction);
        
        
    }
    func moveDown(by:CGFloat = 30)
    {
        let moveAction = SKAction.moveTo(y: self.getPosition().y - by, duration: 0.2);
        
        self.run(moveAction);
        
        
    }
    
    func think(_ currentTime:CFTimeInterval)
    {
        self.weapon.position = self.position;
        
        if(self.weapon != nil)
        {
            self.weapon.think(currentTime);
        }
    }

    
    
    func setPosition(myPosition:CGPoint)
    {
        self.position = myPosition;
    }
    
    func getPosition() -> CGPoint {
        return self.position;
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
