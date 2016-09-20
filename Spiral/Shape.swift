//
//  Shape.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-7-12.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import UIKit
import SpriteKit

enum PathOrientation:Int {
    case right = 0
    case down
    case left
    case up
}

func randomPath() -> PathOrientation{
    let pathNum = Int(arc4random_uniform(4))
    return PathOrientation(rawValue: pathNum)!
}

class Shape: SKSpriteNode {
    var radius:CGFloat = 10
    var moveSpeed:CGFloat = 60
    var pathOrientation:PathOrientation = randomPath()
    var lineNum = 0
    let speedUpBase:CGFloat = 50
    var light = SKLightNode()
    weak var owner: SpriteComponent?
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(name aName:String,imageName:String) {
        super.init(texture: SKTexture(imageNamed: imageName),color:SKColor.clear, size: CGSize(width: radius * 2.0, height: radius * 2.0))
//        physicsBody = SKPhysicsBody(texture: texture, size: size)
        physicsBody = SKPhysicsBody(circleOfRadius: radius)
        physicsBody!.usesPreciseCollisionDetection = true
        physicsBody!.collisionBitMask = mainSceneCategory
        physicsBody!.contactTestBitMask = playerCategory|killerCategory|scoreCategory|shieldCategory|reaperCategory
        moveSpeed += Data.sharedData.speedScale * speedUpBase
        name = aName
        zPosition = 100
        physicsBody?.angularDamping = 0
        physicsBody?.linearDamping = 0
        physicsBody?.restitution = 1
        physicsBody?.friction = 1
        normalTexture = texture?.generatingNormalMap()
        light.isEnabled = false
        addChild(light)
    }
    
    func runInOrdinaryMap(_ map:OrdinaryMap) {
        let distance = calDistanceInOrdinaryMap(map)
        let duration = distance / moveSpeed
        let rotate = SKAction.rotate(byAngle: distance/10, duration: Double(duration))
        let move = SKAction.move(to: map.points[lineNum+1], duration: Double(duration))
        let group = SKAction.group([rotate,move])
        self.run(group, completion:{
            self.lineNum += 1
            if self.lineNum==map.points.count-1 {
                if self is Player{
                    Data.sharedData.gameOver = true
                }
                else{
                    self.removeFromParent()
                }
            }
            else {
                self.runInOrdinaryMap(map)
            }
        })
    }
    
    func calDistanceInOrdinaryMap(_ map:OrdinaryMap)->CGFloat{
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
    
    func runInZenMap(_ map:ZenMap){
        let distance = calDistanceInZenMap(map)
        let duration = distance/moveSpeed
        let rotate = SKAction.rotate(byAngle: distance/10, duration: Double(duration))
        let move = SKAction.move(to: map.points[pathOrientation]![lineNum+1], duration: Double(duration))
        let group = SKAction.group([rotate,move])
        self.run(group, completion: {
            self.lineNum += 1
            if self.lineNum==map.points[self.pathOrientation]!.count-1 {
                if self is Player{
                    Data.sharedData.gameOver = true
                }
                else{
                    self.removeFromParent()
                }
            }
            else {
                self.runInZenMap(map)
            }
        })
    }
    
    func calDistanceInZenMap(_ map:ZenMap)->CGFloat{
        if self.lineNum==map.points[pathOrientation]!.count {
            return 0
        }
        let turnNum:Int
        switch pathOrientation {
        case .right:
            turnNum = lineNum
        case .down:
            turnNum = lineNum + 1
        case .left:
            turnNum = lineNum + 2
        case .up:
            turnNum = lineNum + 3
        }
        switch turnNum%4{
        case 0:
            return map.points[pathOrientation]![lineNum+1].x-position.x
        case 1:
            return position.y-map.points[pathOrientation]![lineNum+1].y
        case 2:
            return position.x-map.points[pathOrientation]![lineNum+1].x
        case 3:
            return map.points[pathOrientation]![lineNum+1].y-position.y
        default:
            return 0
        }
    }

}
