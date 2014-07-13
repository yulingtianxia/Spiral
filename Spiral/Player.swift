//
//  Player.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-7-13.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//
import SpriteKit

class Player: Shape {
    convenience init() {
        self.init(name:"player",imageName:"player")
        self.physicsBody.categoryBitMask = playerCategory
    }
    func runInMap(map:Map){
//        self.runAction(SKAction.group([SKAction.followPath(map.path, speed: self.moveSpeed),SKAction.repeatActionForever(SKAction.rotateByAngle(1, duration: 1))]))
//        let rotate = SKAction.repeatActionForever(SKAction.rotateByAngle(5, duration: 1))
        let rotate = SKAction.rotateByAngle(5, duration: 1)
        let move = SKAction.followPath(map.path, speed: self.moveSpeed)
        let group = SKAction.group([rotate,move])
        self.runAction(group)

        
    }
}
