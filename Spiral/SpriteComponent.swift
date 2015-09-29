
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
    
    let sprite: SpriteNode
    let defaultColor: SKColor
    
    init(sprite s: SpriteNode, defaultColor color: SKColor) {
        sprite = s
        defaultColor = color
        super.init()
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
        sprite.color = defaultColor
    }
    
    func useFleeAppearance() {
        sprite.color = SKColor.whiteColor()
    }
    
    func useDefeatedAppearance() {
        sprite.runAction(SKAction.scaleTo(0.25, duration: 0.25))
    }
    
//    MARK: - Movement
    
    var nextGridPosition: vector_int2 = vector_int2(0, 0) {
        willSet {
            guard nextGridPosition == newValue else {
                let action = SKAction.moveTo((sprite.scene as! MazeModeScene).pointForGridPosition(newValue), duration: 0.35)
                let update = SKAction.runBlock({ () -> Void in
                    (entity as? Entity)?.gridPosition = newValue
                })
                
                sprite.runAction(SKAction.sequence([action, update]), withKey: "move")
                return
            }
        }
    }
    
    func warpToGridPosition(gridPosition: vector_int2) {
        let fadeOut = SKAction.fadeOutWithDuration(0.5)
        let warp = SKAction.moveTo(((sprite.scene as? MazeModeScene)?.pointForGridPosition(gridPosition))!, duration:0.5)
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
            if let point = (sprite.scene as? MazeModeScene)?.pointForGridPosition(node.gridPosition) {
                sequence.append(SKAction.moveTo(point, duration: 0.15))
                sequence.append(SKAction.runBlock({ () -> Void in
                    (entity as? Entity)?.gridPosition = node.gridPosition
                }))
            }
        }
        
        sequence.append(SKAction.runBlock(completionHandler))
        sprite.runAction(SKAction.sequence(sequence))
    }
}
