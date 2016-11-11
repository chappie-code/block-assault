//
//  GameScene.swift
//  block-assault
//
//  Created by Edward McIntosh on 2016-08-01.
//  Copyright (c) 2016 Edward McIntosh. All rights reserved.
//

import SpriteKit


struct PhysicsCategory {
    static let None         : UInt32 = 0
    static let All          : UInt32 = UInt32.max
    static let Player       : UInt32 = 0b1       // 1
    static let Monster      : UInt32 = 0b10      // 2
    static let Projectile   : UInt32 = 0b11      // 3
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
    var player:Player;
    var monstersDestroyed = 0;
    var playerHealth = 0;
    
    var displayObjects:Dictionary = [String:NSObject]();
    
    
    override init(size: CGSize) {
        
        self.player = Player();
        super.init(size: size);
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        
        // 3
        let label = SKLabelNode(fontNamed: "Chalkduster")
        let c:String = String(format:"%.1f", player.health);
        label.text = c;
        label.fontSize = 40;
        label.fontColor = SKColor.black;
        label.position = CGPoint(x: 0, y: self.size.height - 40);
        addChild(label)
        
        
        
        
        self.physicsWorld.gravity = CGVector.zero;
        self.physicsWorld.contactDelegate = self;
        
        

        // 2
        backgroundColor = SKColor.white
        // 3
        player.setPosition(myPosition: CGPoint(x: size.width / 2 , y: size.height * 0.9));
        // 4
        addChild(player.spriteObject)
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addMonster),
                SKAction.wait(forDuration: 1.0)
                ])
            ));
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("action");
        // 1) choose the touch to work with
        guard let touch = touches.first else{
            return;
        }
        let touchLocation = touch.location(in: self);
        
        // 2) Set up initial location of projectile
        
        let projectile = SKSpriteNode(imageNamed: "projectile");
        projectile.position = player.getPosition();
        
        
        
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.None
        projectile.physicsBody?.usesPreciseCollisionDetection = true
        
        // 3) determin offset of location to projectile
        let offset = touchLocation - projectile.position;
        
        // 4) Bail out if you are shooting down or backwards
        /*
        if(0.0 > offset.x)
        {
            return
        }
        */
        
        // 5) Ok to add now - you've double checked position
        
        addChild(projectile);
        
        // 6) get the direction of where to shoot
        let direction = offset.normalized();
        
        // 7 Make it shoot far enough to be guaranteed off screen
        let shootAmount = direction * 1000;
        
        // 8) Add the shot amount to the current position
        let realDest = shootAmount + projectile.position;
        
        // 9) Create the action
        let actionMove = SKAction.move(to: realDest,duration: 2.0);
        let actionMoveDone = SKAction.removeFromParent();
        projectile.run(SKAction.sequence([actionMove,actionMoveDone]));
        
    }
    
    func updateDisplay()
    {
    
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
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
        if ((firstBody.categoryBitMask == PhysicsCategory.Monster) && (secondBody.categoryBitMask == PhysicsCategory.Projectile))
        {
            projectileDidCollideWithMonster(monster: firstBody.node as! SKSpriteNode, projectile: secondBody.node as! SKSpriteNode)
        }
        if ((firstBody.categoryBitMask == PhysicsCategory.Player) && (secondBody.categoryBitMask == PhysicsCategory.Monster))
        {
            monsterDidCollideWithPlayer(player: firstBody.node as! SKSpriteNode, monster: secondBody.node as! SKSpriteNode);
        }
        
        
    }
    
    
    func monsterDidCollideWithPlayer(player:SKSpriteNode, monster:SKSpriteNode) {
        print("Hit Player")
        
        monster.removeFromParent()
        
        self.player.removeHealth(by: 5) ;
        print(self.player.health);
    }
    
    func projectileDidCollideWithMonster(monster:SKSpriteNode, projectile:SKSpriteNode) {
        print("Hit")
        projectile.removeFromParent()
        monster.removeFromParent()
        
        monstersDestroyed += 1;
        if (monstersDestroyed > 30) {
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, won: true)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addMonster() {
        
        // Create sprite
        
        
        let myMonster = Monster()
        let yPosition = 0 - myMonster.size.height/2;
        let xPosition = random(min:0, max:self.size.width);
        let position = CGPoint(x: xPosition, y: yPosition);
        
        myMonster.setPosition(myPosition: position);
        
        
        // Add the monster to the scene
        addChild(myMonster.spriteObject);
        
        myMonster.attack(playerPosition: player.getPosition());
        
    }
    
    
    
    
    
}
