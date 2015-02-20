//
//  GameScene.swift
//  FlappyStacheSK
//
//  Created by Scott Graessle on 2/12/15.
//  Copyright (c) 2015 Team Chaos. All rights reserved.
//

import SpriteKit

struct GameConstants {
    static let gravity: CGFloat = -9.8
    static let heroScale: CGFloat = 0.2
    static let heroRect = CGSize(width: 40, height: 80)
    static let heroStart = CGPoint(x: 100, y: 400)
    static let jumpImpulse: CGFloat = 600
    static let speed: Double = 20
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var ourHero: HeroSprite?
    var platforms: [SKNode]?
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.physicsWorld.gravity = CGVectorMake(0.0, GameConstants.gravity);
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody?.categoryBitMask = ColliderType.Edge.rawValue
        
//        world.name = "world"
//        addChild(world)
//        
        ourHero = HeroSprite(atPosition: GameConstants.heroStart)
        self.addChild(ourHero!)
        
        platforms = [SKNode]()
        addPlatform()
    }
    
    func addPlatform() {
        let width = 2048
        let platform = PlatformSprite(width: width)
        var delay = Double(width)/GameConstants.speed/60 + 0.2
        platform.position.x = size.width + CGFloat(width)/2
        platforms?.append(platform)
        addChild(platform)
        runAction(SKAction.sequence(
        [
            SKAction.waitForDuration(delay),
            SKAction.runBlock(addPlatform)
        ]))
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            if let h = ourHero {
                h.jump()
            } else {
                let location = touch.locationInNode(self)
                ourHero = HeroSprite(atPosition: location)
                self.addChild(ourHero!)
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        for p in platforms! {
            p.position.x -= CGFloat(GameConstants.speed)
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        if firstBody.categoryBitMask == ColliderType.Hero.rawValue {
            if secondBody.categoryBitMask == ColliderType.Edge.rawValue {
                debugPrintln("We died.")
                if let h = ourHero {
                    h.removeFromParent()
                    ourHero = nil
                }
            }
        }
    }
}
