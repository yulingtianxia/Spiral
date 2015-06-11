//
//  ReaperContactVisitor.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-10-11.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import SpriteKit

class ReaperContactVisitor: ContactVisitor {
    func visitPlayer(body:SKPhysicsBody){
        let thisNode = self.body.node
        let otherNode = body.node
        
    }
    
    func visitKiller(body:SKPhysicsBody){
        let thisNode = self.body.node as? Reaper
        let otherNode = body.node

        (thisNode?.parent as? GameScene)?.soundManager.playKiller()
    }
    
    func visitScore(body:SKPhysicsBody){
        let thisNode = self.body.node as? Reaper
        let otherNode = body.node

        Data.sharedData.score += 2
        (thisNode?.parent as? GameScene)?.soundManager.playScore()
    }
    
    func visitShield(body:SKPhysicsBody){
        let scene = self.body.node?.scene as? GameScene
        let otherNode = body.node

        scene?.player.shield = true
        Data.sharedData.score++
        scene?.soundManager.playShield()
    }
    
//    func visitReaper(body:SKPhysicsBody){
//        let thisNode = self.body.node
//        let otherNode = body.node
//        thisNode?.removeFromParent()
//    }
}
