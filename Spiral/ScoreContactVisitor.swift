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
    func visitPlayer(_ body:SKPhysicsBody){
        if let thisNode = self.body.node as? Score {
            guard Data.sharedData.currentMode == .maze else {
                thisNode.removeFromParent()
                return
            }
        }
    }
    
    func visitKiller(_ body:SKPhysicsBody){
        let thisNode = self.body.node
//        let otherNode = body.node
        thisNode?.removeFromParent()
    }
    
    func visitScore(_ body:SKPhysicsBody){
        let thisNode = self.body.node
//        let otherNode = body.node
        thisNode?.removeFromParent()
    }
    
    func visitShield(_ body:SKPhysicsBody){
        let thisNode = self.body.node
//        let otherNode = body.node
        thisNode?.removeFromParent()
    }
    
    func visitReaper(_ body:SKPhysicsBody){
        if let thisNode = self.body.node as? Score {
            guard Data.sharedData.currentMode == .maze else {
                thisNode.removeFromParent()
                return
            }
        }
    }
}
