//
//  Player.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-7-13.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//
import SpriteKit

class Player: Shape {
    var jump = false
    convenience init() {
        self.init(name:"Player",imageName:"player")
        self.physicsBody.categoryBitMask = playerCategory
        self.moveSpeed = 60
    }
    
}
