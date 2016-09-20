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
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == ShapeDefeatedState.self
    }
    
    override func didEnter(from previousState: GKState?) {
        // Set the shape sprite to its normal appearance, undoing any changes that happened in other states.
        if let component = entity.component(ofType: SpriteComponent.self) {
            component.useNormalAppearance()
        }
        
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        // If the shape has reached its target, choose a new target.
        let position = entity.gridPosition
        var path = [GKGraphNode]()
        var nearest = Int.max
        for shape in scene.shapes {
            if let aiComponent = shape.component(ofType: IntelligenceComponent.self),
                let state = aiComponent.stateMachine.currentState
                , state.isKind(of: ShapeDefeatedState.self)
                    || state.isKind(of: ShapeRespawnState.self) {
                        continue
            }
            let expectPath: [GKGraphNode]
            if let cachePath = scene.pathCache[line_int4(pa: position, pb: shape.gridPosition)] {
                expectPath = cachePath
            }
            else if let sourceNode = scene.map.pathfindingGraph.node(atGridPosition: position),
                let targetNode = scene.map.pathfindingGraph.node(atGridPosition: shape.gridPosition) {
                    expectPath = scene.map.pathfindingGraph.findPath(from: sourceNode, to: targetNode)
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
