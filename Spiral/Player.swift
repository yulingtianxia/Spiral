//
//  Player.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-7-13.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//
import SpriteKit

class Player: Shape {
    var shield: Bool = false {
        willSet{
            if shield != newValue {
                if newValue {
                    self.texture = SKTexture(imageNamed: "player0")
                    light.enabled = true
                }
                else{
                    self.texture = SKTexture(imageNamed: "player")
                    light.enabled = false
                }
            }
        }
        didSet {
            if shield {
                (scene as? MazeModeScene)?.hasPowerup = true
            }
        }
    }
    
    convenience init() {
        self.init(name:"Player",imageName:"player")
        self.physicsBody?.categoryBitMask = playerCategory
        self.moveSpeed = 90
        light.lightColor = SKColor(red: 80.0/255, green: 227.0/255, blue: 194.0/255, alpha: 1)
        light.categoryBitMask = playerLightCategory
    }
    
    func restart() {
        alpha = 1
        removeAllActions()
        lineNum = 0
        moveSpeed = 90
        shield = false
    }
}
