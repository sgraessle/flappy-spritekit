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
    
    class func create(location: CGPoint) -> HeroSprite {
        let heroAnimatedAtlas = SKTextureAtlas(named: "Hero")
        var walkFrames = [SKTexture]()
        
        let numImages = heroAnimatedAtlas.textureNames.count
        for var i=1; i<=numImages; i++ {
            let textureName = "running0\(i)"
            walkFrames.append(heroAnimatedAtlas.textureNamed(textureName))
        }
        
        let firstFrame = walkFrames[0]
        let sprite = HeroSprite(texture: firstFrame)
        sprite.runFrames = walkFrames
        sprite.xScale = GameConstants.heroScale
        sprite.yScale = GameConstants.heroScale
        sprite.position = location
        sprite.configurePhysicsBody()
        sprite.runningHero()
        return sprite
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
    
    func flap() {
        physicsBody!.velocity = CGVectorMake(0, 0)
        physicsBody!.applyImpulse(CGVectorMake(0, GameConstants.jumpImpulse))

        runAction(SKAction.animateWithTextures(runFrames!, timePerFrame: 0.2))
    }
}