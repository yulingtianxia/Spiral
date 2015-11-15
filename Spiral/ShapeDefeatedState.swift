//
//  ShapeDefeatedState.swift
//  Spiral
//
//  Created by 杨萧玉 on 15/9/30.
//  Copyright © 2015年 杨萧玉. All rights reserved.
//

import GameplayKit
import SpriteKit

class ShapeDefeatedState: ShapeState {
    let respawnPosition: GKGridGraphNode
    
    init(scene s: MazeModeScene, entity e: Entity, respawnPosition respawn: GKGridGraphNode) {
        respawnPosition = respawn
        super.init(scene: s, entity: e)
    }
    
    //    MARK: - GKState Life Cycle
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass == ShapeRespawnState.self
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        // Change the shape sprite's appearance to indicate defeat.
        if let component = entity.componentForClass(SpriteComponent.self) {
            component.useDefeatedAppearance()
            if entity.shapeType == .Reaper {
                let minseconds = 0.25 * Double(NSEC_PER_SEC)
                let dtime = dispatch_time(DISPATCH_TIME_NOW, Int64(minseconds))
                dispatch_after(dtime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                    self.entity.componentForClass(SpriteComponent.self)?.sprite.removeFromParent()
                })
            }
            // Use pathfinding to find a route back to this shape's starting position.
            if let path = pathToNode(respawnPosition) {
                component.followPath(path, completion: { () -> Void in
                    self.stateMachine?.enterState(ShapeRespawnState.self)
                })
            }
        }
    }
}
