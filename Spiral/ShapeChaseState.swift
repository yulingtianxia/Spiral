//
//  ShapeChaseState.swift
//  Spiral
//
//  Created by 杨萧玉 on 15/9/30.
//  Copyright © 2015年 杨萧玉. All rights reserved.
//

import GameplayKit

class ShapeChaseState: ShapeState {
    fileprivate let ruleSystem = GKRuleSystem()
    fileprivate var hunting: Bool = false {
        willSet {
            if hunting != newValue && !newValue {
                let playerPos = scene.playerEntity.gridPosition
                //将目标点设为 player 周围的随机点
                let targets = [
                    vector_int2(playerPos.x, playerPos.y + 2),
                    vector_int2(playerPos.x + 2, playerPos.y),
                    vector_int2(playerPos.x, playerPos.y - 2),
                    vector_int2(playerPos.x - 2, playerPos.y),
                    vector_int2(playerPos.x, playerPos.y + 3),
                    vector_int2(playerPos.x + 3, playerPos.y),
                    vector_int2(playerPos.x, playerPos.y - 3),
                    vector_int2(playerPos.x - 3, playerPos.y)].flatMap({ (position) -> GKGridGraphNode? in
                        return scene.map.pathfindingGraph.node(atGridPosition: position)
                    })
                
                if let positions = scene.random.arrayByShufflingObjects(in: targets) as? [GKGridGraphNode] {
                    scatterTarget = positions.first!
                }
            }
        }
    }
    
    fileprivate var scatterTarget = GKGridGraphNode(gridPosition: vector_int2(0, 0))
    
    override init(scene s: MazeModeScene, entity e: Entity) {
        
        super.init(scene: s, entity: e)

        let playerFar = NSPredicate(format: "$distanceToPlayer.floatValue >= 12.0")
        ruleSystem.add(GKRule(predicate: playerFar, assertingFact: "hunt" as NSObjectProtocol, grade: 1.0))
        
        let playerNear = NSPredicate(format: "$distanceToPlayer.floatValue < 12.0")
        ruleSystem.add(GKRule(predicate: playerNear, retractingFact: "hunt" as NSObjectProtocol, grade: 1.0))
    }
    
//    MARK: - GKState Life Cycle
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == ShapeFleeState.self || stateClass == ShapeDefeatedState.self
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
        if position == scatterTarget.gridPosition {
            hunting = true
        }
        
        if let distanceToPlayer = pathToPlayer()?.count {
            ruleSystem.state["distanceToPlayer"] = distanceToPlayer
            ruleSystem.reset()
            ruleSystem.evaluate()
        }
        
        hunting = ruleSystem.grade(forFact: "hunt" as NSObjectProtocol) > 0.0
        if hunting {
            startFollowingPath(pathToPlayer())
        }
        else {
            startFollowingPath(pathToNode(scatterTarget))
        }
    }
}
