//
//  ShapeReapState.swift
//  Spiral
//
//  Created by 杨萧玉 on 15/10/6.
//  Copyright © 2015年 杨萧玉. All rights reserved.
//

import GameplayKit

class ShapeReapState: ShapeState {
    
    override init(scene s: MazeModeScene, entity e: Entity) {
        
        super.init(scene: s, entity: e)
        
    }
    
    
    //    MARK: - GKState Life Cycle
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass == ShapeDefeatedState.self
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        // Set the shape sprite to its normal appearance, undoing any changes that happened in other states.
        if let component = entity.componentForClass(SpriteComponent.self) {
            component.useNormalAppearance()
        }
        
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        // If the shape has reached its target, choose a new target.
        let position = entity.gridPosition
        var path = [GKGraphNode]()
        var nearest = Int.max
        for shape in scene.shapes {
            if let aiComponent = shape.componentForClass(IntelligenceComponent.self),
                let state = aiComponent.stateMachine.currentState
                where state.isKindOfClass(ShapeDefeatedState.self)
                    || state.isKindOfClass(ShapeRespawnState.self) {
                        continue
            }
            let expectPath: [GKGraphNode]
            if let cachePath = scene.pathCache[line_int4(pa: position, pb: shape.gridPosition)] {
                expectPath = cachePath
            }
            else if let sourceNode = scene.map.pathfindingGraph.nodeAtGridPosition(position),
                let targetNode = scene.map.pathfindingGraph.nodeAtGridPosition(shape.gridPosition) {
                    expectPath = scene.map.pathfindingGraph.findPathFromNode(sourceNode, toNode: targetNode)
                    scene.pathCache[line_int4(pa: position, pb: shape.gridPosition)] = (expectPath as! [GKGridGraphNode])
                    if expectPath.count < nearest {
                        path = expectPath
                        nearest = expectPath.count
                    }
            }
        }
        
        startFollowingPath(path as? [GKGridGraphNode])
    }
}
