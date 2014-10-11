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
        //        println(thisNode.name+"->"+otherNode.name)
    }
    func visitKiller(body:SKPhysicsBody){
        let thisNode = self.body.node as Reaper
        let otherNode = body.node!
        otherNode.removeFromParent()
        (thisNode.parent as GameScene).soundManager.playKiller()
    }
    func visitScore(body:SKPhysicsBody){
        let thisNode = self.body.node as Reaper
        let otherNode = body.node
        //        println(thisNode.name+"->"+otherNode.name)
        otherNode!.removeFromParent()
        Data.score += 2
        (thisNode.parent as GameScene).soundManager.playScore()
    }
    func visitShield(body:SKPhysicsBody){
        let scene = self.body.node?.scene as GameScene
        let otherNode = body.node
        otherNode!.removeFromParent()
        scene.player.shield = true
        Data.score++
        scene.soundManager.playShield()
    }
}
