//
//  ShapeState.swift
//  Spiral
//
//  Created by 杨萧玉 on 15/9/30.
//  Copyright © 2015年 杨萧玉. All rights reserved.
//

import GameplayKit

class ShapeState: GKState {
    weak var scene: MazeModeScene?
    let entity: Entity
    init(scene s: MazeModeScene, entity e: Entity) {
        scene = s
        entity = e
        
        super.init()
    }
    
    func pathToNode(node: GKGridGraphNode) -> [GKGridGraphNode]? {
        if let graph = scene?.map.pathfindingGraph, let sourceNode = graph.nodeAtGridPosition(entity.gridPosition) {
            return graph.findPathFromNode(sourceNode, toNode: node) as? [GKGridGraphNode]
        }
        return nil
    }
    
    func startFollowingPath(path: [GKGridGraphNode]) {
        /*
        Set up a move to the first node on the path, but
        no farther because the next update will recalculate the path.
        */
        if path.count > 1 {
            let firstMove = path[1] // path[0] is the shape's current position.
            let component = entity.componentForClass(SpriteComponent)
            component?.nextGridPosition = firstMove.gridPosition
        }
    }
}
