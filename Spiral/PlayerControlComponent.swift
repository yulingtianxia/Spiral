//
//  PlayerControlComponent.swift
//  Spiral
//
//  Created by 杨萧玉 on 15/9/29.
//  Copyright © 2015年 杨萧玉. All rights reserved.
//

import GameplayKit

enum PlayerDirection: Int {
    case None
    case Left
    case Right
    case Down
    case Up
}

class PlayerControlComponent: GKComponent {
    let map: MazeMap
    
    private var nextNode: GKGridGraphNode!
    
    var direction: PlayerDirection = .None {
        willSet {
//            let proposedNode: GKGridGraphNode?
//            if newValue != .None {
//                proposedNode = nodeInDirection(newValue, fromNode: nextNode)
//            }
//            else {
//                if let currentNode = map.pathfindingGraph.nodeAtGridPosition(((entity as? Entity)?.gridPosition)!) {
//                    proposedNode = nodeInDirection(newValue, fromNode: currentNode)
//                }
//            }
        }
    }
    
    var attemptedDirection: PlayerDirection = .None
    
    init(map m: MazeMap) {
        map = m
        super.init()
    }
    
    func nodeInDirection(direction: PlayerDirection, fromNode node: GKGridGraphNode) -> GKGridGraphNode? {
        let nextPosition: vector_int2
        switch direction {
        case .Left:
            nextPosition = node.gridPosition + vector_int2(-1, 0)
        case .Right:
            nextPosition = node.gridPosition + vector_int2(1, 0)
        case .Down:
            nextPosition = node.gridPosition + vector_int2(0, -1)
        case .Up:
            nextPosition = node.gridPosition + vector_int2(0, 1)
        case .None:
            return nil
        }
        return map.pathfindingGraph.nodeAtGridPosition(nextPosition)
    }
    
    func makeNextMove() {
        if let currentNode = map.pathfindingGraph.nodeAtGridPosition(((entity as? Entity)?.gridPosition)!) {
            if let attemptedNextNode = nodeInDirection(attemptedDirection, fromNode: currentNode) {
                //改变方向
                direction = attemptedDirection
                nextNode = attemptedNextNode
            }
            else if let autoNextNode = nodeInDirection(direction, fromNode: currentNode) {
                //方向没变化，继续直走
                nextNode = autoNextNode
            }
            else {
                //不能再动了
                direction = .None
                return
            }
            // 给负责精灵动画的组件设置下一步移动的位置
            if let component = entity?.componentForClass(SpriteComponent) {
                component.nextGridPosition = nextNode.gridPosition
            }
        }
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        makeNextMove()
    }
    
}


