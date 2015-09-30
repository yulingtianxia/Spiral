//
//  ShapeDefeatedState.swift
//  Spiral
//
//  Created by 杨萧玉 on 15/9/30.
//  Copyright © 2015年 杨萧玉. All rights reserved.
//

import GameplayKit

class ShapeDefeatedState: ShapeState {
    let respawnPosition: GKGridGraphNode
    
    init(scene s: MazeModeScene, entity e: Entity, respawnPosition respawn: GKGridGraphNode) {
        respawnPosition = respawn
        super.init(scene: s, entity: e)
    }
}
