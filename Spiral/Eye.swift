//
//  Eye.swift
//  Spiral
//
//  Created by 杨萧玉 on 14/10/25.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import SpriteKit

class Eye: SKSpriteNode {
    init() {
        super.init(texture: SKTexture(imageNamed: "eye"), color: UIColor.clearColor(), size: CGSize(width: 20, height: 20))
        physicsBody = SKPhysicsBody(circleOfRadius: 10)
        physicsBody?.categoryBitMask = eyeCategory
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = playerCategory
        name = "Eye"
    }
    
    func lookAtNode(node:SKNode){
        constraints = [SKConstraint.orientToNode(node, offset:SKRange(constantValue:CGFloat(3*M_PI_4)))]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
