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
    var display:Display!;
    var playerIsTouching:Bool;
    var cam:Camera!;
    
    
    override init(size: CGSize) {
        
        self.playerIsTouching = false;
        
        self.player = Player();
        
        super.init(size: size);
        
        

        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func swipedRight(sender:UISwipeGestureRecognizer){

        player.moveRight();
        player.weapon.playerStoppedTouch();
        cam.moveTo(position: player.position);
    }
    
    func swipedLeft(sender:UISwipeGestureRecognizer){

        player.moveLeft();
        player.weapon.playerStoppedTouch();
        cam.moveTo(position: player.position);
    }
    
    func swipedUp(sender:UISwipeGestureRecognizer){
        
        player.moveUp();
        player.weapon.playerStoppedTouch();
        cam.moveTo(position: player.position);
    }
    
    func swipedDown(sender:UISwipeGestureRecognizer){
        
        player.moveDown();
        player.weapon.playerStoppedTouch();
        cam.moveTo(position: player.position);
    }
    
    
    override func didMove(to view: SKView) {
        
        self.player.setParentScene(scene: self.scene!);
        print("set scene");
        
        let texture = SKTexture(noiseWithSmoothness: 0.9, size: CGSize(width: 20, height: 20), grayscale: true);
        
        let background = SKSpriteNode(texture: texture, color: UIColor.black, size: self.size)
        background.colorBlendFactor = 0.5;
        
        let center = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        background.position = center
        background.lightingBitMask = 1
        addChild(background);
        
        
       
        /*
        let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swipedRight(sender:)));
        swipeRight.direction = .right
        swipeRight.cancelsTouchesInView = false;
        view.addGestureRecognizer(swipeRight)
        
        
        
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swipedLeft(sender:)));
        swipeLeft.direction = .left;
        swipeLeft.cancelsTouchesInView = false;
        view.addGestureRecognizer(swipeLeft)
        
        
        let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swipedUp(sender:)));
        swipeUp.direction = .up
        swipeUp.cancelsTouchesInView = false;
        view.addGestureRecognizer(swipeUp)
        
        
        let swipeDown:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swipedDown(sender:)));
        swipeDown.direction = .down;
        swipeDown.cancelsTouchesInView = false;
        view.addGestureRecognizer(swipeDown)
        
 */
        
        let zoomGesture:UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(self.pinched(sender:)));
        view.addGestureRecognizer(zoomGesture)
        
        let panGesture:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.panned(sender:)));
        view.addGestureRecognizer(panGesture);
        panGesture.cancelsTouchesInView = false;
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressed(sender:)));
        view.addGestureRecognizer(longPressRecognizer);
        //longPressRecognizer.cancelsTouchesInView = true;
        longPressRecognizer.delaysTouchesBegan = true;
        
        
        
        self.physicsWorld.gravity = CGVector.zero;
        self.physicsWorld.contactDelegate = self;
        
                
        addChild(player);
        
        self.display = Display(size: self.size);
        
        addChild(display.healthLabel);
        addChild(display.scoreLabel);
        addChild(display.changeWeaponButton);
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addMonster),
                SKAction.wait(forDuration: 2.0)
                ])
            ));
        

        
        
        
        self.cam = Camera()
        
        self.camera = cam //set the scene's camera to reference cam
        self.addChild(cam) //make the cam a childElement of the scene itself.
        
        //position the camera on the gamescene.
        cam.position = center;
    }
    
    func pinched(sender:UIPinchGestureRecognizer)
    {
        print("pinched");
        print(sender.scale);
        self.cam.setScale(sender.scale)
    }
    
    func longPressed(sender: UILongPressGestureRecognizer)
    {
        print(sender.description);
        
    }
    
    func panned(sender: UIPanGestureRecognizer)
    {
        
        //sender.require(toFail: UITapGestureRecognizer.Type);
        
        //self.player.swordSwing();
        let x = sender.velocity(in: self.view).x;
        let y = sender.velocity(in: self.view).y;
        
        if(y > 0)
        {
            print("hih");
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else{
            return;
        }
        let touchLocation = touch.location(in: self);
        
        
        player.weapon.playerTouched(point: touchLocation);
        
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{
            return;
        }
        let touchLocation = touch.location(in: self);
        
        player.weapon.playerTouched(point: touchLocation);
        

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        player.weapon.playerStoppedTouch();
        self.playerIsTouching = false;
        
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
        
        if (firstBody.node == nil || secondBody.node == nil)
        {
            print("returned early - from collisions detection");
            return;
            
        }
        
        // 2
        if ((firstBody.categoryBitMask == PhysicsCategory.Monster) && (secondBody.categoryBitMask == PhysicsCategory.Projectile))
        {
            
                let monster:Monster = firstBody.node as! Monster;
            
            let projectile:SKShapeNode = secondBody.node as! SKShapeNode;
            
            
            projectileDidCollideWithMonster(monster: monster, projectile: projectile)
        }
        if ((firstBody.categoryBitMask == PhysicsCategory.Player) && (secondBody.categoryBitMask == PhysicsCategory.Monster))
        {
            monsterDidCollideWithPlayer(player: firstBody.node as! Player, monster: secondBody.node as! Monster);
        }
        
        
    }
    
    func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject()! as! UITouch
        let location = touch.location(in: self)
        
        print(location);
    }
    
    
    func monsterDidCollideWithPlayer(player:Player, monster:Monster) {
        print("Hit Player")
        
        monster.removeFromParent();
        
        
        player.removeHealth(by: 5) ;
        self.display.updateHealth(health: player.health);
        print(self.player.health);
    }
    
    func projectileDidCollideWithMonster(monster:Monster, projectile:SKShapeNode) {
        print("Hit")
        projectile.removeFromParent()
        
        
        monster.reduceHealth()
        if(monster.health == 0)
        {
            print("Killed");
            monster.removeFromParent();
            player.updateScore(increase: 1);
            monstersDestroyed += 1;
        }
        
        
        
        display.updateScore(score: player.getScore());
        
        
        if (monstersDestroyed > 30) {
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, won: true)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        for child in self.children {
            if (child is Monster)
            {
                
                //Update monsters to the player position
                if (self.player != nil)
                {
                    let monster = child as? Monster;
                    monster?.updatePlayer(position: player.position);
                    monster?.think(currentTime);
                    
                }
                
                //update player to focus on nearest monster
                if (self.player != nil)
                {
                    let monster = child as? Monster;
                    if(self.distanceBetween(pointOne: (monster?.position)!, pointTwo: player.position) < 100)
                    {
                        //print("monster Added");
                        player.addMonsterPoint(position: (monster?.position)!);
                        
                    }
                    else
                    {
                        
                        
                    }
                    
                }
                
                
                
            }
            
            
        }
        
        if ( self.player != nil)
        {
            self.player.think(currentTime);
            
            
        }
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
        let yPosition = myMonster.size.height;
        let xPosition = random(min:0, max:self.size.width);
        let position = CGPoint(x: xPosition, y: 0 - yPosition);
        
        myMonster.position = position;
        //myMonster.lastKnownPlayerPosition = player.position;
        
        
        // Add the monster to the scene
        addChild(myMonster);
        
        myMonster.attack(playerPosition: player.position);
        print(player.position)
        
        
    }
    
    func distanceBetween(pointOne:CGPoint, pointTwo:CGPoint) -> CGFloat
    {
        let xDist:CGFloat = (pointTwo.x - pointOne.x);
        let yDist:CGFloat = (pointTwo.y - pointOne.y);
        let distance:CGFloat = sqrt((xDist * xDist) + (yDist * yDist));
        return distance;
    }
    
    
    
    
    
    
    
}
