//
//  ShapeRespawnState.swift
//  Spiral
//
//  Created by 杨萧玉 on 15/9/30.
//  Copyright © 2015年 杨萧玉. All rights reserved.
//

import GameplayKit

class ShapeRespawnState: ShapeState {
    var timeRemaining: TimeInterval
     = 0.0
    //    MARK: - GKState Life Cycle
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == ShapeChaseState.self || stateClass == ShapeFleeState.self
    }
    
    override func didEnter(from previousState: GKState?) {
        let defaultRespawnTime: TimeInterval = 10
        timeRemaining = defaultRespawnTime
        
        if let component = entity.component(ofType: SpriteComponent.self) {
            component.pulseEffectEnabled = true
        }
    }
    
    override func willExit(to nextState: GKState) {
        // Restore the sprite's original appearance.
        if let component = entity.component(ofType: SpriteComponent.self) {
            component.pulseEffectEnabled = false
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        timeRemaining -= seconds
        if timeRemaining < 0 {
            switch entity.shapeType {
            case .killer:
                stateMachine?.enter(ShapeChaseState.self)
            case .score, .shield:
                stateMachine?.enter(ShapeFleeState.self)
            case .player, .reaper:
                break
            }
        }
    }
}
