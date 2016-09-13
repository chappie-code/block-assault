//
//  GameScene.swift
//  block-assault
//
//  Created by Edward McIntosh on 2016-08-01.
//  Copyright (c) 2016 Edward McIntosh. All rights reserved.
//

import SpriteKit

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
    func sqrt(a: CGFloat) -> CGFloat {
        return CGFloat(sqrtf(Float(a)))
    }
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}


class GameScene: SKScene {
    // 1
    let player = SKSpriteNode(imageNamed: "player")
    
    override func didMoveToView(view: SKView) {
        // 2
        backgroundColor = SKColor.whiteColor()
        // 3
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        // 4
        addChild(player)
        
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(addMonster),
                SKAction.waitForDuration(1.0)
                ])
            ));
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // 1) choose the touch to work with
        guard let touch = touches.first else{
            return;
        }
        let touchLocation = touch.locationInNode(self);
        
        // 2) Set up initial location of projectile
        
        let projectile = SKSpriteNode(imageNamed: "projectile");
        projectile.position = player.position;
        
        // 3) determin offset of location to projectile
        let offset = touchLocation - projectile.position;
        
        // 4) Bail out if you are shooting down or backwards
        if(0.0 > offset.x)
        {
            return
        }
        
        // 5) Ok to add now - you've double checked position
        
        addChild(projectile);
        
        // 6) get the direction of where to shoot
        let direction = offset.normalized();
        
        // 7 Make it shoot far enough to be guaranteed off screen
        let shootAmount = direction * 1000;
        
        // 8) Add the shot amount to the current position
        let realDest = shootAmount + projectile.position;
        
        // 9) Create the action
        let actionMove = SKAction.moveTo(realDest,duration: 2.0);
        let actionMoveDone = SKAction.removeFromParent();
        projectile.runAction(SKAction.sequence([actionMove,actionMoveDone]));
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addMonster() {
        
        // Create sprite
        let monster = SKSpriteNode(imageNamed: "monster")
        
        // Determine where to spawn the monster along the Y axis
        let actualY = random(min: monster.size.height/2, max: size.height - monster.size.height/2)
        
        // Position the monster slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
        monster.position = CGPoint(x: size.width + monster.size.width/2, y: actualY)
        
        // Add the monster to the scene
        addChild(monster)
        
        // Determine speed of the monster
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        // Create the actions
        let actionMove = SKAction.moveTo(CGPoint(x: -monster.size.width/2, y: actualY), duration: NSTimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        monster.runAction(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    
}
