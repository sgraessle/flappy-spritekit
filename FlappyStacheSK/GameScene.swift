//
//  GameScene.swift
//  FlappyStacheSK
//
//  Created by Scott Graessle on 2/12/15.
//  Copyright (c) 2015 Team Chaos. All rights reserved.
//

import SpriteKit

struct GameConstants {
    static let gravity: CGFloat = -5.8
    static let heroScale: CGFloat = 0.25
    static let heroRect = CGSize(width: 20, height: 40)
    static let jumpImpulse: CGFloat = 600
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var ourHero: HeroSprite?
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.physicsWorld.gravity = CGVectorMake(0.0, GameConstants.gravity);
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody?.categoryBitMask = ColliderType.Edge.rawValue
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            if let h = ourHero {
                h.flap()
            } else {
                let location = touch.locationInNode(self)
                ourHero = HeroSprite.create(location)
                self.addChild(ourHero!)
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
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
                ourHero!.removeFromParent()
                ourHero = nil
            }
        }
    }
}
