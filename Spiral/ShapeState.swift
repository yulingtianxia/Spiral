//
//  ShapeState.swift
//  Spiral
//
//  Created by 杨萧玉 on 15/9/30.
//  Copyright © 2015年 杨萧玉. All rights reserved.
//

import GameplayKit

class ShapeState: GKState {
    unowned var scene: MazeModeScene
    let entity: Entity
    init(scene s: MazeModeScene, entity e: Entity) {
        scene = s
        entity = e
        
        super.init()
    }
    
    func pathToNode(node: GKGridGraphNode) -> [GKGridGraphNode]? {
        let graph = scene.map.pathfindingGraph
        if let path = scene.pathCache[line_int4(pa: entity.gridPosition, pb: node.gridPosition)] {
            return path
        }
        if let sourceNode = graph.nodeAtGridPosition(entity.gridPosition),
            let path = graph.findPathFromNode(sourceNode, toNode: node) as? [GKGridGraphNode] {
            scene.pathCache[line_int4(pa: entity.gridPosition, pb: node.gridPosition)] = path
            return path
        }
        return nil
    }
    
    func pathToPlayer() -> [GKGridGraphNode]? {
        let graph = scene.map.pathfindingGraph
        if let playerNode = graph.nodeAtGridPosition(scene.playerEntity.gridPosition) {
            return pathToNode(playerNode)
        }
        return nil
    }
    
    func startFollowingPath(path: [GKGridGraphNode]?) {
        /*
        Set up a move to the first node on the path, but
        no farther because the next update will recalculate the path.
        */
        if let path = path where path.count > 1 {
            let firstMove = path[1] // path[0] is the shape's current position.
            let component = entity.componentForClass(SpriteComponent)
            component?.nextGridPosition = firstMove.gridPosition
            if path.count > 2 {
                component?.secondNextGridPosition = path[2].gridPosition
            }
        }
    }
    
    func startRunToNode(node: GKGridGraphNode) {
        let component = entity.componentForClass(SpriteComponent)
        component?.nextGridPosition = node.gridPosition
    }
}
