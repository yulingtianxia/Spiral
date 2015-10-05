//
//  ShapeRespawnState.swift
//  Spiral
//
//  Created by 杨萧玉 on 15/9/30.
//  Copyright © 2015年 杨萧玉. All rights reserved.
//

import GameplayKit

class ShapeRespawnState: ShapeState {
    var timeRemaining: NSTimeInterval
     = 0.0
    //    MARK: - GKState Life Cycle
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass == ShapeChaseState.self || stateClass == ShapeFleeState.self
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        let defaultRespawnTime: NSTimeInterval = 10
        timeRemaining = defaultRespawnTime
        
        if let component = entity.componentForClass(SpriteComponent.self) {
            component.pulseEffectEnabled = true
        }
    }
    
    override func willExitWithNextState(nextState: GKState) {
        // Restore the sprite's original appearance.
        if let component = entity.componentForClass(SpriteComponent.self) {
            component.pulseEffectEnabled = false
        }
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        timeRemaining -= seconds
        if timeRemaining < 0 {
            switch entity.shapeType {
            case .Killer:
                stateMachine?.enterState(ShapeChaseState.self)
            case .Score, .Shield:
                stateMachine?.enterState(ShapeFleeState.self)
            case .Player, .Reaper:
                break
            }
        }
    }
}
