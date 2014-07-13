//
//  Shape.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-7-12.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import UIKit
import SpriteKit



class Shape: SKSpriteNode {
    let radius:CGFloat = 15
    var moveSpeed:CGFloat = 50
    init(name:String,imageName:String){
        super.init(texture: SKTexture(imageNamed: imageName),color:SKColor.clearColor(), size: CGSizeMake(radius*2, radius*2))
        self.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        self.physicsBody.usesPreciseCollisionDetection = true
        self.physicsBody.collisionBitMask = 0
        self.physicsBody.contactTestBitMask = playerCategory|killerCategory|scoreCategory
        self.name = name
        self.physicsBody.angularDamping = 0
        
    }
}
