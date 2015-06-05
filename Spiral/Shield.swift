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
        light.lightColor = SKColor(red: 144.0/255, green: 19.0/255, blue: 254.0/255, alpha: 1)
        light.categoryBitMask = shieldLightCategory
    }
}
