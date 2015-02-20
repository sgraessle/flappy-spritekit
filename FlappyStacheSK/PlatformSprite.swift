//
//  PlatformSprite.swift
//  FlappyStacheSK
//
//  Created by Scott Graessle on 2/19/15.
//  Copyright (c) 2015 Team Chaos. All rights reserved.
//

import Foundation
import SpriteKit

class PlatformSprite : SKSpriteNode {
    
    init(width: Int) {
        let tex = SKTexture(imageNamed: "Ground_Tile")
        let size = tex.size()
        super.init(texture: tex, color: UIColor.whiteColor(), size: size)
        
        configurePhysicsBody(width)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configurePhysicsBody(width: Int) {
        var collisionSize = CGSize(width: width, height: 32)
        
        physicsBody = SKPhysicsBody(rectangleOfSize: collisionSize)
        physicsBody?.categoryBitMask = ColliderType.Platform.rawValue
        physicsBody?.dynamic = false
        physicsBody!.affectedByGravity = false
        physicsBody!.allowsRotation = false
        
        position = CGPoint(x: 256, y: 200)
    }
}