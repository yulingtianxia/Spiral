//
//  PlayerContactVisitor.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-7-14.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import Foundation
import SpriteKit
class PlayerContactVisitor:ContactVisitor{
    func visitPlayer(body:SKPhysicsBody){
        let thisNode = self.body.node
        let otherNode = body.node
//        println(thisNode.name+"->"+otherNode.name)
    }
    func visitKiller(body:SKPhysicsBody){
        let thisNode = self.body.node as Player
        let otherNode = body.node
//        println(thisNode.name+"->"+otherNode.name)
        if thisNode.shield {
            otherNode.removeFromParent()
            thisNode.shield = false
        }
        else {
            Data.gameOver = true
        }
    }
    func visitScore(body:SKPhysicsBody){
        let thisNode = self.body.node
        let otherNode = body.node
//        println(thisNode.name+"->"+otherNode.name)
        otherNode.removeFromParent()
        Data.score += 2
    }
    func visitShield(body:SKPhysicsBody){
        let thisNode = self.body.node as Player
        let otherNode = body.node
        otherNode.removeFromParent()
        thisNode.shield = true
        Data.score++
        //        println(thisNode.name+"->"+otherNode.name)
    }
}