//
//  ReaperContactVisitor.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-10-11.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import SpriteKit

class ReaperContactVisitor: ContactVisitor {
    func visitPlayer(body:SKPhysicsBody) {
//        let thisNode = self.body.node
//        let otherNode = body.node
        
    }
    
    func visitKiller(body:SKPhysicsBody) {
        let thisNode = self.body.node as! Reaper
        let otherNode = body.node as! Killer
        if Data.sharedData.currentMode == .Maze {
            if let entity = thisNode.owner?.entity,
                let aiComponent = entity.componentForClass(IntelligenceComponent.self),
                let state = aiComponent.stateMachine.currentState {
                    if !state.isKindOfClass(ShapeReapState.self) {
                        return
                    }
                    else {
                        aiComponent.stateMachine.enterState(ShapeDefeatedState.self)
                    }
            }
            if let entity = otherNode.owner?.entity,
                let aiComponent = entity.componentForClass(IntelligenceComponent.self),
                let state = aiComponent.stateMachine.currentState {
                    if !state.isKindOfClass(ShapeChaseState.self) {
                        return
                    }
                    else {
                        aiComponent.stateMachine.enterState(ShapeDefeatedState.self)
                    }
            }
        }
        (thisNode.scene as? GameScene)?.soundManager.playKiller()
    }
    
    func visitScore(body:SKPhysicsBody) {
        let thisNode = self.body.node as! Reaper
        let otherNode = body.node as! Score
        if Data.sharedData.currentMode == .Maze {
            if let entity = thisNode.owner?.entity,
                let aiComponent = entity.componentForClass(IntelligenceComponent.self),
                let state = aiComponent.stateMachine.currentState {
                    if !state.isKindOfClass(ShapeReapState.self) {
                        return
                    }
            }
            if let entity = otherNode.owner?.entity,
                let aiComponent = entity.componentForClass(IntelligenceComponent.self),
                let state = aiComponent.stateMachine.currentState {
                    if !state.isKindOfClass(ShapeFleeState.self) {
                        return
                    }
                    else {
                        aiComponent.stateMachine.enterState(ShapeDefeatedState.self)
                    }
            }
        }
        Data.sharedData.score += 2
        (thisNode.scene as? GameScene)?.soundManager.playScore()
    }
    
    func visitShield(body:SKPhysicsBody) {
        let scene = self.body.node?.scene as? GameScene
        let thisNode = self.body.node as! Reaper
        let otherNode = body.node as! Shield
        if Data.sharedData.currentMode == .Maze {
            if let entity = thisNode.owner?.entity,
                let aiComponent = entity.componentForClass(IntelligenceComponent.self),
                let state = aiComponent.stateMachine.currentState {
                    if !state.isKindOfClass(ShapeReapState.self) {
                        return
                    }
            }
            if let entity = otherNode.owner?.entity,
                let aiComponent = entity.componentForClass(IntelligenceComponent.self),
                let state = aiComponent.stateMachine.currentState {
                    if !state.isKindOfClass(ShapeFleeState.self) {
                        return
                    }
                    else {
                        aiComponent.stateMachine.enterState(ShapeDefeatedState.self)
                    }
            }
        }
        
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
