//
//  ShapeChaseState.swift
//  Spiral
//
//  Created by 杨萧玉 on 15/9/30.
//  Copyright © 2015年 杨萧玉. All rights reserved.
//

import GameplayKit

class ShapeChaseState: ShapeState {
    private let ruleSystem = GKRuleSystem()
    private var hunting: Bool = false {
        willSet {
            if hunting != newValue && !newValue {
                if let positions = scene.random.arrayByShufflingObjectsInArray(scene.map.shapeStartPositions) as? [GKGridGraphNode] {
                    scatterTarget = positions.first!
                }
            }
        }
    }
    private var scatterTarget: GKGridGraphNode!
    
    override init(scene s: MazeModeScene, entity e: Entity) {
        
        super.init(scene: s, entity: e)
        
        let playerFar = NSPredicate(format: "$distanceToPlayer.floatValue >= 10.0")
        ruleSystem.addRule(GKRule(predicate: playerFar, assertingFact: "hunt", grade: 1.0))
        
        let playerNear = NSPredicate(format: "$distanceToPlayer.floatValue < 10.0")
        ruleSystem.addRule(GKRule(predicate: playerNear, retractingFact: "hunt", grade: 1.0))
    }
    
    func pathToPlayer() -> [GKGridGraphNode]? {
        let graph = scene.map.pathfindingGraph
        if let playerNode = graph.nodeAtGridPosition(scene.player.gridPosition) {
            return pathToNode(playerNode)
        }
        return nil
    }
    
//    MARK: - GKState Life Cycle
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass == ShapeFleeState.self
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
        if position == scatterTarget.gridPosition {
            hunting = true
        }
        
        if let distanceToPlayer = pathToPlayer()?.count {
            ruleSystem.state["distanceToPlayer"] = distanceToPlayer
            ruleSystem.reset()
            ruleSystem.evaluate()
        }
        
        hunting = ruleSystem.gradeForFact("hunt") > 0.0
        if hunting {
            startFollowingPath(pathToPlayer())
        }
        else {
            startFollowingPath(pathToNode(scatterTarget))
        }
    }
}
