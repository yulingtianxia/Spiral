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
    func visitPlayer(body:SKPhysicsBody){
        if let thisNode = self.body.node as? Killer {
            if Data.sharedData.currentMode == .Maze {
                if let entity = thisNode.owner?.entity,
                let aiComponent = entity.componentForClass(IntelligenceComponent.self),
                let state = aiComponent.stateMachine.currentState {
                    guard state.isKindOfClass(ShapeChaseState.self) else {
                        aiComponent.stateMachine.enterState(ShapeDefeatedState.self)
                        return
                    }
                }
            }
            else {
                thisNode.removeFromParent()
            }
        }
    }
    
    func visitKiller(body:SKPhysicsBody){
        let thisNode = self.body.node
//        let otherNode = body.node
        thisNode?.removeFromParent()
    }
    
    func visitScore(body:SKPhysicsBody){
//        let thisNode = self.body.node
//        let otherNode = body.node

    }
    
    func visitShield(body:SKPhysicsBody){
        let thisNode = self.body.node
//        let otherNode = body.node
        thisNode?.removeFromParent()
    }
    
    func visitReaper(body:SKPhysicsBody){
        if let thisNode = self.body.node as? Killer {
            if Data.sharedData.currentMode == .Maze {
                if let entity = thisNode.owner?.entity,
                    let aiComponent = entity.componentForClass(IntelligenceComponent.self),
                    let state = aiComponent.stateMachine.currentState {
                        guard state.isKindOfClass(ShapeChaseState.self) else {
                            aiComponent.stateMachine.enterState(ShapeDefeatedState.self)
                            return
                        }
                }
            }
            else {
                thisNode.removeFromParent()
            }
        }
    }
}