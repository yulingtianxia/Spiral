//
//  ReaperContactVisitor.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-10-11.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import SpriteKit

class ReaperContactVisitor: ContactVisitor {
    @objc func visitPlayer(_ body:SKPhysicsBody) {
//        let thisNode = self.body.node
//        let otherNode = body.node
        
    }
    
    @objc func visitKiller(_ body:SKPhysicsBody) {
        let thisNode = self.body.node as! Reaper
        let otherNode = body.node as! Killer
        if Data.sharedData.currentMode == .maze {
            if let entity = thisNode.owner?.entity,
                let aiComponent = entity.component(ofType: IntelligenceComponent.self),
                let state = aiComponent.stateMachine.currentState {
                    if !state.isKind(of: ShapeReapState.self) {
                        return
                    }
                    else {
                        aiComponent.stateMachine.enter(ShapeDefeatedState.self)
                    }
            }
            if let entity = otherNode.owner?.entity,
                let aiComponent = entity.component(ofType: IntelligenceComponent.self),
                let state = aiComponent.stateMachine.currentState {
                    if !state.isKind(of: ShapeChaseState.self) {
                        return
                    }
                    else {
                        aiComponent.stateMachine.enter(ShapeDefeatedState.self)
                    }
            }
        }
        (thisNode.scene as? GameScene)?.soundManager.playKiller()
    }
    
    @objc func visitScore(_ body:SKPhysicsBody) {
        let thisNode = self.body.node as! Reaper
        let otherNode = body.node as! Score
        if Data.sharedData.currentMode == .maze {
            if let entity = thisNode.owner?.entity,
                let aiComponent = entity.component(ofType: IntelligenceComponent.self),
                let state = aiComponent.stateMachine.currentState {
                    if !state.isKind(of: ShapeReapState.self) {
                        return
                    }
            }
            if let entity = otherNode.owner?.entity,
                let aiComponent = entity.component(ofType: IntelligenceComponent.self),
                let state = aiComponent.stateMachine.currentState {
                    if !state.isKind(of: ShapeFleeState.self) {
                        return
                    }
                    else {
                        aiComponent.stateMachine.enter(ShapeDefeatedState.self)
                    }
            }
        }
        Data.sharedData.score += 2
        (thisNode.scene as? GameScene)?.soundManager.playScore()
    }
    
    @objc func visitShield(_ body:SKPhysicsBody) {
        let scene = self.body.node?.scene as? GameScene
        let thisNode = self.body.node as! Reaper
        let otherNode = body.node as! Shield
        if Data.sharedData.currentMode == .maze {
            if let entity = thisNode.owner?.entity,
                let aiComponent = entity.component(ofType: IntelligenceComponent.self),
                let state = aiComponent.stateMachine.currentState {
                    if !state.isKind(of: ShapeReapState.self) {
                        return
                    }
            }
            if let entity = otherNode.owner?.entity,
                let aiComponent = entity.component(ofType: IntelligenceComponent.self),
                let state = aiComponent.stateMachine.currentState {
                    if !state.isKind(of: ShapeFleeState.self) {
                        return
                    }
                    else {
                        aiComponent.stateMachine.enter(ShapeDefeatedState.self)
                    }
            }
        }
        
        scene?.player.shield = true
        Data.sharedData.score += 1
        scene?.soundManager.playShield()
    }
    
//    @objc func visitReaper(body:SKPhysicsBody){
//        let thisNode = self.body.node
//        let otherNode = body.node
//        thisNode?.removeFromParent()
//    }
}
