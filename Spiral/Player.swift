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
    var shield:Bool = false {
    willSet{
        if newValue{
            self.texture = SKTexture(imageNamed: "player0")
        }
        else{
            self.texture = SKTexture(imageNamed: "player")
        }
    }
    }
    convenience init() {
        self.init(name:"Player",imageName:"player")
        self.physicsBody!.categoryBitMask = playerCategory
        self.moveSpeed = 70
        self.lineNum = 3
    }
    func restart(map:Map) {
        self.alpha = 1
        self.removeAllActions()
        self.lineNum = 3
        self.moveSpeed = 70
        self.jump = false
        self.shield = false
        self.position = map.points[self.lineNum]
        self.runInMap(map)
    }
}
