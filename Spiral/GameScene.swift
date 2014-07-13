//
//  GameScene.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-7-12.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    let player:Player
    let map:Map
    
    init(size:CGSize){
        let center = CGPointMake(size.width/2, size.height/2)
        player = Player()
        player.position = CGPointZero
        map = Map(origin:center, layer: 5)
        
        super.init(size:size)
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.addChild(map)
        self.addChild(player)
        player.runInMap(map)
    }
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
//        for touch: AnyObject in touches {
//            let location = touch.locationInNode(self)
//            
//            let sprite = SKSpriteNode(imageNamed:"Spaceship")
//            
//            sprite.xScale = 0.5
//            sprite.yScale = 0.5
//            sprite.position = location
//            
//            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
//            
//            sprite.runAction(SKAction.repeatActionForever(action))
//            
//            self.addChild(sprite)
//        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
