//
//  HeroSprite.swift
//  FlappyStacheSK
//
//  Created by Scott Graessle on 2/13/15.
//  Copyright (c) 2015 Team Chaos. All rights reserved.
//

import Foundation
import SpriteKit

enum ColliderType: UInt32 {
    case Hero = 1
    case Platform = 2
    case Beast = 4
    case Pickup = 8
    case Edge = 16

    static var colliders = ColliderType.Platform.rawValue | ColliderType.Beast.rawValue
}

class HeroSprite : SKSpriteNode {
    var collisionRadius: CGFloat {
        return 40.0
    }
    var runFrames: [SKTexture]?
    
    init(atPosition: CGPoint, frames: [SKTexture]) {
        let first = frames[0]
        super.init(texture: first, color: SKColor.whiteColor(), size: first.size())
        
        runFrames = frames
        xScale = GameConstants.heroScale
        yScale = GameConstants.heroScale
        position = atPosition
        configurePhysicsBody()
        runningHero()
    }
    
    convenience init(atPosition: CGPoint) {
        let heroAnimatedAtlas = SKTextureAtlas(named: "Hero")
        var walkFrames = [SKTexture]()
        
        let numImages = heroAnimatedAtlas.textureNames.count
        for var i=1; i<=numImages; i++ {
            let textureName = "running0\(i)"
            walkFrames.append(heroAnimatedAtlas.textureNamed(textureName))
        }
        
        self.init(atPosition: atPosition, frames: walkFrames)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configurePhysicsBody() {
        // Assign the physics body; unwrap the physics body to configure it.
        physicsBody = SKPhysicsBody(rectangleOfSize: GameConstants.heroRect)
        physicsBody!.dynamic = true
        physicsBody!.affectedByGravity = true
        physicsBody!.allowsRotation = false
        physicsBody!.mass = 1
        physicsBody!.categoryBitMask = ColliderType.Hero.rawValue
        physicsBody!.collisionBitMask = ColliderType.colliders
        physicsBody!.contactTestBitMask = ColliderType.Edge.rawValue | ColliderType.Pickup.rawValue
    }
    
    func runningHero() {
        runAction(SKAction.repeatActionForever(
            SKAction.animateWithTextures(runFrames!,
                timePerFrame: 0.1,
                resize: false,
                restore: true)),
            withKey: "runningHero")
    }
    
    func jump() {
        physicsBody!.velocity = CGVectorMake(0, 0)
        physicsBody!.applyImpulse(CGVectorMake(0, GameConstants.jumpImpulse))
   }
}