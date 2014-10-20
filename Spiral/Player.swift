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
        if newValue {
            if !shield {
                self.texture = SKTexture(imageNamed: "player0")
                light.enabled = true
            }
        }
        else{
            self.texture = SKTexture(imageNamed: "player")
            light.enabled = false
        }
    }
    }
    
    convenience init() {
        self.init(name:"Player",imageName:"player")
        self.physicsBody!.categoryBitMask = playerCategory
        self.moveSpeed = 90
        self.lineNum = 3
        light.lightColor = SKColor(red: 80.0/255, green: 227.0/255, blue: 194.0/255, alpha: 1)
        light.categoryBitMask = playerLightCategory
    }
    
    func restart(map:Map) {
        self.alpha = 1
        self.removeAllActions()
        self.lineNum = 3
        self.moveSpeed = 90
        self.jump = false
        self.shield = false
        self.position = map.points[self.lineNum]
        self.runInMap(map)
    }
}
