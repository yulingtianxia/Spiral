//
//  Score.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-7-14.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import SpriteKit

class Score: Shape {
    convenience init() {
        self.init(name:"Score",imageName:"score")
        self.physicsBody!.categoryBitMask = scoreCategory
        light.lightColor = SKColor.greenColor()
        light.categoryBitMask = scoreLightCategory
    }
}
