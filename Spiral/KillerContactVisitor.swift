//
//  KillerContactVisitor.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-7-14.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import Foundation
import SpriteKit
class KillerContactVisitor:ContactVisitor{
    @objc func visitPlayer(_ body:SKPhysicsBody){
        if let thisNode = self.body.node as? Killer {
            guard Data.sharedData.currentMode == .maze else {
                thisNode.removeFromParent()
                return
            }
        }
    }
    
    @objc func visitKiller(_ body:SKPhysicsBody){
        let thisNode = self.body.node
//        let otherNode = body.node
        thisNode?.removeFromParent()
    }
    
    @objc func visitScore(_ body:SKPhysicsBody){
//        let thisNode = self.body.node
//        let otherNode = body.node

    }
    
    @objc func visitShield(_ body:SKPhysicsBody){
        let thisNode = self.body.node
//        let otherNode = body.node
        thisNode?.removeFromParent()
    }
    
    @objc func visitReaper(_ body:SKPhysicsBody){
        if let thisNode = self.body.node as? Killer {
            guard Data.sharedData.currentMode == .maze else {
                thisNode.removeFromParent()
                return
            }
        }
    }
}
