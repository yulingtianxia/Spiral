//
//  Reaper.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-10-11.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import SpriteKit

class Reaper: Shape {
    convenience init() {
        self.init(name:"Reaper",imageName:"reaper")
        self.physicsBody!.categoryBitMask = reaperCategory
        self.moveSpeed = 250
        light.lightColor = SKColor(red: 78.0/255, green: 146.0/255, blue: 223.0/255, alpha: 1)
        light.categoryBitMask = reaperLightCategory
        light.enabled = true
    }
}
