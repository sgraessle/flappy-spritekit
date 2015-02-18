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
    case Wall = 2

    static var all = ColliderType.Hero.rawValue | ColliderType.Wall.rawValue
}

class HeroSprite : SKSpriteNode {
    var collisionRadius: CGFloat {
        return 40.0
    }
    var staches: [SKTexture]?
    
    class func create(location: CGPoint) -> HeroSprite {
        let sprite = HeroSprite(imageNamed: "PinkStache")
        sprite.staches = [SKTexture(imageNamed: "PinkStache2"), SKTexture(imageNamed: "PinkStache")]
        sprite.xScale = 0.5
        sprite.yScale = 0.5
        sprite.position = location
        sprite.configurePhysicsBody()
        return sprite
    }

    func configurePhysicsBody() {
        // Assign the physics body; unwrap the physics body to configure it.
        physicsBody = SKPhysicsBody(circleOfRadius: collisionRadius)
        physicsBody!.dynamic = true
        physicsBody!.affectedByGravity = true
        physicsBody!.mass = 1
        physicsBody!.categoryBitMask = ColliderType.Hero.rawValue
        physicsBody!.collisionBitMask = ColliderType.Wall.rawValue
        physicsBody!.contactTestBitMask = ColliderType.Wall.rawValue
    }
    
    func flap() {
        physicsBody!.velocity = CGVectorMake(0, 0)
        physicsBody!.applyImpulse(CGVectorMake(0, 500.0))

        runAction(SKAction.animateWithTextures(staches!, timePerFrame: 0.15))
    }

}