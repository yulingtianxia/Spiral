
//
//  SpriteComponent.swift
//  Spiral
//
//  Created by 杨萧玉 on 15/9/29.
//  Copyright © 2015年 杨萧玉. All rights reserved.
//

import GameplayKit
import SpriteKit

class SpriteComponent: GKComponent {
    
    let sprite: Shape
    
    init(entity: Entity) {
        
        switch entity.shapeType {
        case .Player:
            sprite = Player()
        case .Killer:
            sprite = Killer()
            sprite.physicsBody?.contactTestBitMask = playerCategory | reaperCategory
        case .Score:
            sprite = Score()
            sprite.physicsBody?.contactTestBitMask = playerCategory | reaperCategory
        case .Shield:
            sprite = Shield()
            sprite.physicsBody?.contactTestBitMask = playerCategory | reaperCategory
        case .Reaper:
            sprite = Reaper()
            sprite.physicsBody?.contactTestBitMask = playerCategory
        }
        super.init()
        sprite.owner = self
    }
    
//    MARK: - Appearance
    
    var pulseEffectEnabled: Bool = false {
        didSet {
            if pulseEffectEnabled {
                let grow = SKAction.scaleBy(1.5, duration: 0.5)
                let sequence = SKAction.sequence([grow, grow.reversedAction()])
                sprite.runAction(SKAction.repeatActionForever(sequence), withKey: "pulse")
            }
            else {
                sprite.removeActionForKey("pulse")
                sprite.runAction(SKAction.scaleTo(1.0, duration: 0.5))
            }
        }
    }
    
    func useNormalAppearance() {
        //TODO: 普通外观
//        sprite.color = defaultColor
    }
    
    func useFleeAppearance() {
        //TODO: 逃逸外观
//        sprite.color = SKColor.whiteColor()
    }
    
    func useDefeatedAppearance() {
        sprite.runAction(SKAction.scaleTo(0.25, duration: 0.25))
    }
    
//    MARK: - Movement
    
    var nextGridPosition: vector_int2 = vector_int2(0, 0) {
        willSet {
            if nextGridPosition != newValue {
//                移动到下个节点，设置速度
                let action = SKAction.moveTo(pointForGridPosition(newValue), duration: durationForDistance(mazeCellWidth))
                let update = SKAction.runBlock({ () -> Void in
                    (entity as? Entity)?.gridPosition = newValue
                })
                
                sprite.runAction(SKAction.sequence([action, update]), withKey: "move")
                return
            }
        }
    }
    
    //通过渐变的动画变换位置
    func warpToGridPosition(gridPosition: vector_int2) {
        let fadeOut = SKAction.fadeOutWithDuration(0.5)
        let warp = SKAction.moveTo(pointForGridPosition(gridPosition), duration:0.5)
        let fadeIn = SKAction.fadeInWithDuration(0.5)
        let update = SKAction.runBlock({
            (entity as? Entity)?.gridPosition = gridPosition
        })
        
        sprite.runAction(SKAction.sequence([fadeOut, update, warp, fadeIn]))
    }
    
    func followPath(path: [GKGridGraphNode], completion completionHandler: Void -> Void) {
        // Ignore the first node in the path -- it's the starting position.
        let dropFirst = path[1 ..< path.count]
        
        var sequence = [SKAction]()
        
        for node in dropFirst {
            //溃逃回复活点的动画
            let point = pointForGridPosition(node.gridPosition)
            sequence.append(SKAction.moveTo(point, duration: 0.15))
            sequence.append(SKAction.runBlock({ () -> Void in
                (entity as? Entity)?.gridPosition = node.gridPosition
            }))
        }
        
        sequence.append(SKAction.runBlock(completionHandler))
        sprite.runAction(SKAction.sequence(sequence))
    }
    
    func durationForDistance(distance: CGFloat) -> NSTimeInterval {
        return NSTimeInterval(distance / sprite.moveSpeed)
    }
}
