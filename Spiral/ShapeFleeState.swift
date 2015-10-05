//
//  ShapeFleeState.swift
//  Spiral
//
//  Created by 杨萧玉 on 15/9/30.
//  Copyright © 2015年 杨萧玉. All rights reserved.
//

import GameplayKit

class ShapeFleeState: ShapeState {
    private var target: GKGridGraphNode
    
    override init(scene s: MazeModeScene, entity e: Entity) {
        target = (s.random.arrayByShufflingObjectsInArray(s.map.shapeStartPositions).first as? GKGridGraphNode)!
        super.init(scene: s, entity: e)
    }
    
//    MARK: - GKState Life Cycle
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass == ShapeChaseState.self || stateClass == ShapeDefeatedState.self
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        if let component = entity.componentForClass(SpriteComponent.self) {
            component.useFleeAppearance()
        }
        
        // Choose a location to flee towards.
        target = (scene.random.arrayByShufflingObjectsInArray(scene.map.shapeStartPositions).first as? GKGridGraphNode)!
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        //TODO: 计算四个方向的点，选择距离 player 最远的方向
        // If the shape has reached its target, choose a new target.
        let position = entity.gridPosition
        if position == target.gridPosition {
            if let positions = scene.random.arrayByShufflingObjectsInArray(scene.map.shapeStartPositions) as? [GKGridGraphNode] {
                target = positions.first!
            }
        }
        // Flee towards the current target point.
        startFollowingPath(pathToNode(target))
    }
}
