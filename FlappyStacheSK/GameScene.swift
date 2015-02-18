//
//  GameScene.swift
//  FlappyStacheSK
//
//  Created by Scott Graessle on 2/12/15.
//  Copyright (c) 2015 Team Chaos. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var ourHero: HeroSprite?
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.physicsWorld.gravity = CGVectorMake(0, -5.8);

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
}
