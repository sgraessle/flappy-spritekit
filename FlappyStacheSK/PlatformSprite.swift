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
    var width: Int = 0
    
    init(atPosition: CGPoint, width: Int) {
        let size = CGSize(width: width, height: 25)
        super.init(texture: nil, color: SKColor.whiteColor(), size: size)

        position = CGPoint(x: atPosition.x + CGFloat(width)/2, y: atPosition.y)
        let tex = SKTexture(imageNamed: "Ground_Tile")
        let tileSize = tex.size()
        let tileCount = width/Int(tileSize.width)
        let actualWidth = CGFloat(tileCount) * tileSize.width
        let xOffset = actualWidth/2 - tileSize.width/2
        
        //println("Tile size \(tileSize) width \(width) actual \(actualWidth)")
       
        for i in 0..<tileCount {
            let child = SKSpriteNode(texture: tex)
            child.position = CGPoint(x: CGFloat(i) * tileSize.width - xOffset, y: 0)
            addChild(child)
        }
        
        configurePhysicsBody(size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configurePhysicsBody(size: CGSize) {

        physicsBody = SKPhysicsBody(rectangleOfSize: size)
        physicsBody?.categoryBitMask = ColliderType.Platform.rawValue
        physicsBody?.dynamic = false
        physicsBody!.affectedByGravity = false
        physicsBody!.allowsRotation = false
    }
}