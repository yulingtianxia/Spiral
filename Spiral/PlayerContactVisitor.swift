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
//        let thisNode = self.body.node
//        let otherNode = body.node
//        println(thisNode.name+"->"+otherNode.name)
    }
    
    func visitKiller(body:SKPhysicsBody){
        let thisNode = self.body.node as! Player
        let otherNode = body.node as! Killer

        if thisNode.shield {
            // Maze 模式下防止 shape 死亡后被触碰到重复生效
            if Data.sharedData.currentMode == .Maze {
                if let entity = otherNode.owner?.entity,
                    let aiComponent = entity.componentForClass(IntelligenceComponent.self),
                    let state = aiComponent.stateMachine.currentState {
                        if state.isKindOfClass(ShapeFleeState.self) {
                            aiComponent.stateMachine.enterState(ShapeDefeatedState.self)
                        }
                        else {
                            return
                        }
                }
            }
            else {
                thisNode.shield = false
            }
            Data.sharedData.score += 1
            let achievement = GameKitHelper.sharedGameKitHelper.getAchievementForIdentifier(kClean100KillerAchievementID)
            if achievement.percentComplete <= 99.0{
                achievement.percentComplete += 1
            }
            GameKitHelper.sharedGameKitHelper.updateAchievement(achievement, identifier: kClean100KillerAchievementID)
            (thisNode.scene as? GameScene)?.soundManager.playKiller()
        }
        else {
            if Data.sharedData.currentMode == .Maze {
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
            thisNode.removeAllActions()
            Data.sharedData.gameOver = true
        }
    }
    
    func visitScore(body:SKPhysicsBody){
        let thisNode = self.body.node as! Player
        let otherNode = body.node as! Score
        // Maze 模式下防止 shape 死亡后被触碰到重复生效
        if Data.sharedData.currentMode == .Maze {
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
        let achievement = GameKitHelper.sharedGameKitHelper.getAchievementForIdentifier(kCatch500ScoreAchievementID)
        if achievement.percentComplete <= 99.8{
            achievement.percentComplete += 0.2
        }
        GameKitHelper.sharedGameKitHelper.updateAchievement(achievement, identifier: kCatch500ScoreAchievementID)
        (thisNode.scene as? GameScene)?.soundManager.playScore()
    }
    
    func visitShield(body:SKPhysicsBody){
        let thisNode = self.body.node as! Player
        let otherNode = body.node as! Shield
        // Maze 模式下防止 shape 死亡后被触碰到重复生效
        if Data.sharedData.currentMode == .Maze {
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

        thisNode.shield = true
        Data.sharedData.score += 1
        let achievement = GameKitHelper.sharedGameKitHelper.getAchievementForIdentifier(kCatch500ShieldAchievementID)
        if achievement.percentComplete <= 99.8{
            achievement.percentComplete += 0.2
        }
        GameKitHelper.sharedGameKitHelper.updateAchievement(achievement, identifier: kCatch500ShieldAchievementID)
        (thisNode.scene as? GameScene)?.soundManager.playShield()
    }
}