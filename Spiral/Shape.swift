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
    let radius:CGFloat = 10
    var moveSpeed:CGFloat = 50
    var lineNum = 0
    init(name:String,imageName:String){
        super.init(texture: SKTexture(imageNamed: imageName),color:SKColor.clearColor(), size: CGSizeMake(radius*2, radius*2))
        self.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        self.physicsBody.usesPreciseCollisionDetection = true
        self.physicsBody.collisionBitMask = 0
        self.physicsBody.contactTestBitMask = playerCategory|killerCategory|scoreCategory
        moveSpeed += CGFloat(Data.speedScale) * self.moveSpeed
        self.name = name
        self.physicsBody.angularDamping = 0
        
    }
    func runInMap(map:Map){
        let distance = calDistanceInMap(map)
        let duration = distance/moveSpeed
        let rotate = SKAction.rotateByAngle(distance/10, duration: duration)
        let move = SKAction.moveTo(map.points[lineNum+1], duration: duration)
        let group = SKAction.group([rotate,move])
        self.runAction(group, completion: {
            self.lineNum++
            if self.lineNum==map.points.count-1 {
                if self is Player{
                    Data.gameOver = true
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
        switch lineNum%4{
        case 0:
            return position.y-map.points[lineNum+1].y
        case 1:
            return position.x-map.points[lineNum+1].x
        case 2:
            return map.points[lineNum+1].y-position.y
        case 3:
            return map.points[lineNum+1].x-position.x
        default:
            return 0
        }
    }
    

}
