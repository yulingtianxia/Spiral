//
//  MagicRoad.swift
//  Spiral
//
//  Created by 杨萧玉 on 15/10/7.
//  Copyright © 2015年 杨萧玉. All rights reserved.
//

import SpriteKit
import GameplayKit

class MagicRoad: SKNode {
    init(graph: GKGridGraph, position: vector_int2){
        let roadWidth: CGFloat = 2
        
        super.init()
        let left = graph.nodeAtGridPosition(vector_int2(position.x - 1, position.y))
        let right = graph.nodeAtGridPosition(vector_int2(position.x + 1, position.y))
        let up = graph.nodeAtGridPosition(vector_int2(position.x, position.y + 1))
        let down = graph.nodeAtGridPosition(vector_int2(position.x, position.y - 1))
        if left != nil && right != nil && up == nil && down == nil {
            // 一
            if let magic = SKEmitterNode(fileNamed: "magic") {
                magic.particlePositionRange = CGVector(dx: mazeCellWidth, dy: roadWidth)
                addChild(magic)
            }
        }
        else if up != nil && down != nil && left == nil && right == nil {
            // |
            if let magic = SKEmitterNode(fileNamed: "magic") {
                magic.particlePositionRange = CGVector(dx: roadWidth, dy: mazeCellWidth)
                addChild(magic)
            }
        }
        else {
            //丄丅卜十...
            if let magic = SKEmitterNode(fileNamed: "magic") {
                magic.particlePositionRange = CGVector(dx: roadWidth, dy: roadWidth)
                addChild(magic)
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
