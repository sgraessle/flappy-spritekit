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
    static let heroScale: CGFloat = 1
    static let heroRect = CGSize(width: 40, height: 60)
    static let heroStart = CGPoint(x: 100, y: 400)
    static let jumpImpulse: CGFloat = 700
    static let speed: Double = 20
    static let gap: CGFloat = 200
    static let yGround: CGFloat = 40
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var ourHero: HeroSprite?
    var platforms: [PlatformSprite]?
    var backgrounds: [TiledSprite]?
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.physicsWorld.gravity = CGVectorMake(0.0, GameConstants.gravity);
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody?.categoryBitMask = ColliderType.Edge.rawValue

        backgrounds = [TiledSprite]()
        let smallStars = TiledSprite(imageNamed: "BG_Stars_01", size: size, scrollRate: CGFloat(GameConstants.speed - 6))
        smallStars.position = CGPointZero
        addChild(smallStars)
        backgrounds?.append(smallStars)

        let bigStars = TiledSprite(imageNamed: "BG_Stars_02", size: size, scrollRate: CGFloat(GameConstants.speed - 3))
        bigStars.position = CGPointZero
        addChild(bigStars)
        backgrounds?.append(bigStars)

        println("scene size: \(self.size)")
        let tint = SKShapeNode(rectOfSize: self.size)
        tint.fillColor = UIColor(red: 0.15, green: 0.0, blue: 0.11, alpha: 0.8)
        tint.position = CGPoint(x:size.width/2, y:size.height/2)
        self.addChild(tint)

        ourHero = HeroSprite(atPosition: GameConstants.heroStart)
        self.addChild(ourHero!)
        
        platforms = [PlatformSprite]()
        addPlatform(CGPoint(x: 0, y: 50))
    }
    
    func addPlatform(atPosition: CGPoint) {
        let width = 2000
        let platform = PlatformSprite(atPosition: atPosition, width: width)
        platforms?.append(platform)
        addChild(platform)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        for touch in (touches as! Set<UITouch>) {
            println("touch \(touch.locationInNode(self))")
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
        var lastX: CGFloat = 0
        for p in platforms! {
            p.position.x -= CGFloat(GameConstants.speed)
            let trailingX = p.position.x + p.size.width/2
            if trailingX > lastX {
                lastX = trailingX
            }
        }

        if lastX < size.width {
            println("Add platform")
            addPlatform(CGPoint(x: lastX + GameConstants.gap, y: GameConstants.yGround))
        }

        for b in backgrounds! {
            b.update(currentTime)
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
