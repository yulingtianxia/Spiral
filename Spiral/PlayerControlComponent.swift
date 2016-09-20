//
//  PlayerControlComponent.swift
//  Spiral
//
//  Created by 杨萧玉 on 15/9/29.
//  Copyright © 2015年 杨萧玉. All rights reserved.
//

import GameplayKit

enum PlayerDirection: Int {
    case none
    case left
    case right
    case down
    case up
}

class PlayerControlComponent: GKComponent {
    let map: MazeMap
    
    fileprivate var nextNode: GKGridGraphNode!
    
    var direction: PlayerDirection = .none
    
    var attemptedDirection: PlayerDirection = .none
    
    init(map m: MazeMap) {
        map = m
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func nodeInDirection(_ direction: PlayerDirection, fromNode node: GKGridGraphNode) -> GKGridGraphNode? {
        let nextPosition: vector_int2
        switch direction {
        case .left:
            nextPosition = node.gridPosition + vector_int2(-1, 0)
        case .right:
            nextPosition = node.gridPosition + vector_int2(1, 0)
        case .down:
            nextPosition = node.gridPosition + vector_int2(0, -1)
        case .up:
            nextPosition = node.gridPosition + vector_int2(0, 1)
        case .none:
            return nil
        }
        return map.pathfindingGraph.node(atGridPosition: nextPosition)
    }
    
    func makeNextMove() {
        if let currentNode = map.pathfindingGraph.node(atGridPosition: ((entity as? Entity)?.gridPosition)!) {
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
                if direction != .none {
                    (map.scene as? MazeModeScene)?.soundManager.playJump()
                }
                direction = .none
                
                return
            }
            // 给负责精灵动画的组件设置下一步移动的位置
            if let component = entity?.component(ofType: SpriteComponent.self) {
                component.nextGridPosition = nextNode.gridPosition
                component.secondNextGridPosition = nodeInDirection(direction, fromNode: nextNode)?.gridPosition
            }
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        makeNextMove()
    }
    
}


