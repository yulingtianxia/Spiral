//
//  EyeContactVisitor.swift
//  Spiral
//
//  Created by 杨萧玉 on 14/10/25.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import SpriteKit

class EyeContactVisitor: ContactVisitor {
    @objc func visitPlayer(_ body:SKPhysicsBody) {
        self.body.node?.removeFromParent()
        Data.sharedData.gameOver = true
    }
}
