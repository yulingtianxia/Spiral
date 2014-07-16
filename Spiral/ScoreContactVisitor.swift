//
//  ScoreContactVisitor.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-7-14.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import Foundation
import SpriteKit
class ScoreContactVisitor:ContactVisitor{
    func visitPlayer(body:SKPhysicsBody){
        let thisNode = self.body.node
        let otherNode = body.node
//        println(thisNode.name+"->"+otherNode.name)
    }
    func visitKiller(body:SKPhysicsBody){
        let thisNode = self.body.node
        let otherNode = body.node
//        println(thisNode.name+"->"+otherNode.name)
    }
    func visitScore(body:SKPhysicsBody){
        let thisNode = self.body.node
        let otherNode = body.node
//        println(thisNode.name+"->"+otherNode.name)
    }
    func visitShield(body:SKPhysicsBody){
        let thisNode = self.body.node
        let otherNode = body.node
        //        println(thisNode.name+"->"+otherNode.name)
    }
}