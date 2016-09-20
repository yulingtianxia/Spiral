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
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == ShapeRespawnState.self
    }
    
    override func didEnter(from previousState: GKState?) {
        // Change the shape sprite's appearance to indicate defeat.
        if let component = entity.component(ofType: SpriteComponent.self) {
            component.useDefeatedAppearance()
            if entity.shapeType == .reaper {
                let minseconds = 0.25 * Double(NSEC_PER_SEC)
                let dtime = DispatchTime.now() + Double(Int64(minseconds)) / Double(NSEC_PER_SEC)
                DispatchQueue.global(qos: DispatchQoS.QoSClass.default).asyncAfter(deadline: dtime, execute: { () -> Void in
                    self.entity.component(ofType: SpriteComponent.self)?.sprite.removeFromParent()
                })
            }
            // Use pathfinding to find a route back to this shape's starting position.
            if let path = pathToNode(respawnPosition) {
                component.followPath(path, completion: { () -> Void in
                    self.stateMachine?.enter(ShapeRespawnState.self)
                })
            }
        }
    }
}
