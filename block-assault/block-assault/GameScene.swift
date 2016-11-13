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
    var display:Display;
    
    
    
    
    override init(size: CGSize) {
        
        
        self.display = Display();
        self.player = Player();
        
        super.init(size: size);
        
        
        self.player.setParentScene(scene: self.scene!);
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func swipedRight(sender:UISwipeGestureRecognizer){
        print("swiped right")
    }
    
    func swipedLeft(sender:UISwipeGestureRecognizer){
        print("swiped left")
    }
    
    func swipedUp(sender:UISwipeGestureRecognizer){
        print("swiped up")
    }
    
    func swipedDown(sender:UISwipeGestureRecognizer){
        print("swiped down");
        player.swordAnimation();
    }
    
    
    override func didMove(to view: SKView) {
        
        
        let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swipedRight(sender:)));
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swipedLeft(sender:)));
        swipeLeft.direction = .left;
        view.addGestureRecognizer(swipeLeft)
        
        
        let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swipedUp(sender:)));
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        
        
        let swipeDown:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swipedDown(sender:)));
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
        
        self.physicsWorld.gravity = CGVector.zero;
        self.physicsWorld.contactDelegate = self;
        
                

        // 2
        backgroundColor = SKColor.black;
        // 3
        
        // 4
        //addChild(player.spriteObject);
        addChild(display.healthLabel);
        addChild(display.scoreLabel);
        
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
        
        let shapeObject = SKShapeNode(rectOf: CGSize(width: 2, height: 2));
        
        shapeObject.strokeColor = SKColor.white;
        shapeObject.glowWidth = 1.0;
        shapeObject.fillColor = SKColor.orange;
        shapeObject.position = player.getPosition();
        
        
        
        shapeObject.physicsBody = SKPhysicsBody(rectangleOf: CGSize( width: 2, height: 2))
        shapeObject.physicsBody?.isDynamic = true
        shapeObject.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
        shapeObject.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
        shapeObject.physicsBody?.collisionBitMask = PhysicsCategory.None
        shapeObject.physicsBody?.usesPreciseCollisionDetection = true
        
        
        
        // 3) determin offset of location to projectile
        let offset = touchLocation - shapeObject.position;
        
        // 4) Bail out if you are shooting down or backwards
        /*
        if(0.0 > offset.x)
        {
            return
        }
        */
        
        // 5) Ok to add now - you've double checked position
        
        addChild(shapeObject);
        
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
            projectileDidCollideWithMonster(monster: firstBody.node as! SKSpriteNode, projectile: secondBody.node as! SKShapeNode)
        }
        if ((firstBody.categoryBitMask == PhysicsCategory.Player) && (secondBody.categoryBitMask == PhysicsCategory.Monster))
        {
            monsterDidCollideWithPlayer(player: firstBody.node as! SKShapeNode, monster: secondBody.node as! SKSpriteNode);
        }
        
        
    }
    
    
    func monsterDidCollideWithPlayer(player:SKShapeNode, monster:SKSpriteNode) {
        print("Hit Player")
        
        monster.removeFromParent();
        
        
        self.player.removeHealth(by: 5) ;
        self.display.updateHealth(health: self.player.getHealth());
        print(self.player.health);
    }
    
    func projectileDidCollideWithMonster(monster:SKSpriteNode, projectile:SKShapeNode) {
        print("Hit")
        projectile.removeFromParent()
        monster.removeFromParent()
        
        monstersDestroyed += 1;
        player.updateScore(increase: 1);
        display.updateScore(score: player.getScore());
        
        
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
