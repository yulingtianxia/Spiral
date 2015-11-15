//
//  ShapeFleeState.swift
//  Spiral
//
//  Created by 杨萧玉 on 15/9/30.
//  Copyright © 2015年 杨萧玉. All rights reserved.
//

import GameplayKit

class ShapeFleeState: ShapeState {
    private var target: GKGridGraphNode?
    private let ruleSystem = GKRuleSystem()
    private var fleeting: Bool = false {
        willSet {
            if fleeting != newValue && !newValue {
                if let positions = scene.random.arrayByShufflingObjectsInArray(scene.map.shapeStartPositions) as? [GKGridGraphNode] {
                    target = positions.first!
                }
            }
            
        }
    }
    
    override init(scene s: MazeModeScene, entity e: Entity) {
        
//        target = (scene.random.arrayByShufflingObjectsInArray(scene.map.shapeStartPositions).first as? GKGridGraphNode)!
        
        super.init(scene: s, entity: e)
        
        let playerFar = NSPredicate(format: "$distanceToPlayer.floatValue >= 20.0")
        ruleSystem.addRule(GKRule(predicate: playerFar, retractingFact: "flee", grade: 1.0))
        
        let playerNear = NSPredicate(format: "$distanceToPlayer.floatValue < 20.0")
        ruleSystem.addRule(GKRule(predicate: playerNear, assertingFact: "flee", grade: 1.0))

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
        // If the shape has reached its target, choose a new target.
        let position = entity.gridPosition
        if target != nil && position == target!.gridPosition {
            fleeting = true
        }
        
        if let distanceToPlayer = pathToPlayer()?.count {
            ruleSystem.state["distanceToPlayer"] = distanceToPlayer
            ruleSystem.reset()
            ruleSystem.evaluate()
        }
        
        fleeting = ruleSystem.gradeForFact("flee") > 0.0
        if fleeting {
            generateTarget()
            startRunToNode(target!)
        }
        else {
            startFollowingPath(pathToNode(target!))
        }
    }
    
    func generateTarget() {
        let position = entity.gridPosition
        let graph = scene.map.pathfindingGraph
        if let path = pathToPlayer() where path.count > 1 {
            let negativeNode = path[1] // path[0] is the shape's current position.
            let delta = position - negativeNode.gridPosition
            let expectPos = position + delta
            let expectTarget: GKGridGraphNode
            //寻找反方向的点（也就是后退）
            if let expectNode = graph.nodeAtGridPosition(expectPos) {
                expectTarget =  expectNode
            }
            else {
                //反方向如果没有点，那就寻找垂直两个方向（也就是左拐或右拐）
                let orthoDelta = vector_int2(delta.y, delta.x)
                if let expectNode = graph.nodeAtGridPosition(position + orthoDelta) {
                    expectTarget = expectNode
                }
                else if let expectNode = graph.nodeAtGridPosition(position - orthoDelta) {
                    expectTarget = expectNode
                }
                else {
                    expectTarget = graph.nodeAtGridPosition(position)!
                }
            }
            //判断朝着期望的方向逃跑后，距离 player 是否反而更近了
            let expectPath: [GKGraphNode]
            if let cachePath = scene.pathCache[line_int4(pa: expectTarget.gridPosition, pb: scene.playerEntity.gridPosition)] {
                expectPath = cachePath
            }
            else if let playerNode = graph.nodeAtGridPosition(scene.playerEntity.gridPosition) {
                expectPath = graph.findPathFromNode(expectTarget, toNode: playerNode)
                scene.pathCache[line_int4(pa: expectTarget.gridPosition, pb: scene.playerEntity.gridPosition)] = (expectPath as! [GKGridGraphNode])
            }
            else {
                expectPath = [GKGraphNode]()
            }
            
            if expectPath.count <= path.count {
                //原地不动
                target = graph.nodeAtGridPosition(position)!
            }
            else {
                //逃跑
                target = expectTarget
            }
        }
    }
}
