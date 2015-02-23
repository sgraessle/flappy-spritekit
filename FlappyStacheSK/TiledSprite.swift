//
//  TiledSprite.swift
//  FlappyStacheSK
//
//  Created by Scott Graessle on 2/20/15.
//  Copyright (c) 2015 Team Chaos. All rights reserved.
//

import Foundation
import SpriteKit

class TiledSprite : SKNode {
    var scrollRate: CGFloat
    var scrollSize: CGSize

    init(imageNamed: String, size: CGSize, scrollRate: CGFloat) {
        self.scrollRate = scrollRate
        self.scrollSize = size
        self.scrollSize.width *= 2
        super.init()

        let tex = SKTexture(imageNamed: imageNamed)
        let tileSize = tex.size() //CGSize(width: tex.size().width, height: size.height)

        var offset: CGFloat = 0.0
        while offset < scrollSize.width {
            let sprite = SKSpriteNode(texture: tex, color: SKColor.whiteColor(), size: tileSize)
            sprite.position = CGPoint(x: offset - size.width/2 + tileSize.width/2, y: tileSize.height/2)
            addChild(sprite)
            offset += tileSize.width
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(currentTime: CFTimeInterval) {
        for child in self.children {
            if let c = child as? SKSpriteNode {
                c.position.x -= scrollRate
                if c.position.x < -c.size.width {
                    c.position.x += self.scrollSize.width
                }
            }
        }
    }
}
