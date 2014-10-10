//
//  Shield.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-7-16.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import SpriteKit

class Shield: Shape {
    convenience init() {
        self.init(name:"Shield",imageName:"shield")
        self.physicsBody!.categoryBitMask = shieldCategory
        light.lightColor = SKColor.purpleColor()
        light.categoryBitMask = shieldLightCategory
    }
}
