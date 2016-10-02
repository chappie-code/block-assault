//
//  GameScene.swift
//  block-assault
//
//  Created by Edward McIntosh on 2016-08-01.
//  Copyright (c) 2016 Edward McIntosh. All rights reserved.
//

import SpriteKit


struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Monster   : UInt32 = 0b1       // 1
    static let Projectile: UInt32 = 0b10      // 2
}

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


class GameScene: SKScene , SKPhysicsContactDelegate {
    // 1
    let player = SKSpriteNode(imageNamed: "player");
    var monstersDestroyed = 0
    
    override func didMoveToView(view: SKView) {
        
        
        
        
        physicsWorld.gravity = CGVectorMake(0, 0);
        physicsWorld.contactDelegate = self;

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
        
        
        
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
        projectile.physicsBody?.dynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.None
        projectile.physicsBody?.usesPreciseCollisionDetection = true
        
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
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        // 1
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // 2
        if ((firstBody.categoryBitMask & PhysicsCategory.Monster != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Projectile != 0)) {
            projectileDidCollideWithMonster(firstBody.node as! SKSpriteNode, monster: secondBody.node as! SKSpriteNode)
        }
        
    }
    
    func projectileDidCollideWithMonster(projectile:SKSpriteNode, monster:SKSpriteNode) {
        print("Hit")
        projectile.removeFromParent()
        monster.removeFromParent()
        
        monstersDestroyed += 1;
        if (monstersDestroyed > 30) {
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            let gameOverScene = GameOverScene(size: self.size, won: true)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
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
        
        
        let myMonster = Monster()
        let xPosition = self.size.width + myMonster.size.width/2;
        let yPosition = random(min:0, max:self.size.height);
        let position = CGPoint(x: xPosition, y: yPosition);
        
        myMonster.setPosition(position);
        
        
        
        let randomY = random(min: myMonster.size.height/2, max: size.height - myMonster.size.height/2);
        
        // Add the monster to the scene
        addChild(myMonster.spriteObject);
        
        myMonster.attack(randomY);
        
        // Create the actions
        
        
        
        
    }
    
    
    
    
}
