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
    var lineNum = 0
    init(name:String,imageName:String){
        super.init(texture: SKTexture(imageNamed: imageName),color:SKColor.clearColor(), size: CGSizeMake(radius*2, radius*2))
        self.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        self.physicsBody.usesPreciseCollisionDetection = true
        self.physicsBody.collisionBitMask = 0
        self.physicsBody.contactTestBitMask = playerCategory|killerCategory|scoreCategory
        self.name = name
        self.physicsBody.angularDamping = 0
        
    }
    func runInMap(map:Map){
        let distance = calDistanceInMap(map)
        let duration = distance/moveSpeed
        let rotate = SKAction.rotateByAngle(distance/10, duration: duration)
        let move = SKAction.moveTo(map.points[lineNum], duration: duration)
        let group = SKAction.group([rotate,move])
        self.runAction(group, completion: {
            self.lineNum+=1
            if self.lineNum==map.points.count {
                if self is Player{
                    //TODO:gameover
                    println("gameover")
                    (self.parent as GameScene).gameOver = true
                }
                if self is Killer{
                    self.removeFromParent()
                }
                if self is Score{
                    self.removeFromParent()
                }
                
            }
            else {
                self.runInMap(map)
            }
            })
    }
    func calDistanceInMap(map:Map)->CGFloat{
        if self.lineNum==map.points.count {
            return 0
        }
        let point = map.points[lineNum]
        if point.x==position.x{
            return abs(point.y-position.y)
        }
        else if point.y==position.y{
            return abs(point.x-position.x)
        }
        return 0
    }
}
