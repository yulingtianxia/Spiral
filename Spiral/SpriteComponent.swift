
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
        case .player:
            sprite = Player()
        case .killer:
            sprite = Killer()
            sprite.physicsBody?.contactTestBitMask = playerCategory | reaperCategory
        case .score:
            sprite = Score()
            sprite.physicsBody?.contactTestBitMask = playerCategory | reaperCategory
        case .shield:
            sprite = Shield()
            sprite.physicsBody?.contactTestBitMask = playerCategory | reaperCategory
        case .reaper:
            sprite = Reaper()
            sprite.physicsBody?.contactTestBitMask = playerCategory
        }
        super.init()
        sprite.owner = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - Appearance
    
    var pulseEffectEnabled: Bool = false {
        didSet {
            if pulseEffectEnabled {
                let grow = SKAction.scale(by: 1.5, duration: 0.5)
                let sequence = SKAction.sequence([grow, grow.reversed()])
                sprite.run(SKAction.repeatForever(sequence), withKey: "pulse")
            }
            else {
                sprite.removeAction(forKey: "pulse")
                sprite.run(SKAction.scale(to: 1.0, duration: 0.5))
            }
        }
    }
    
    func useNormalAppearance() {
        //TODO: 普通外观
        sprite.color = SKColor.clear
    }
    
    func useFleeAppearance() {
        //TODO: 逃逸外观
        sprite.color = SKColor.white
    }
    
    func useDefeatedAppearance() {
        sprite.run(SKAction.scale(to: 0.25, duration: 0.25))
    }
    
//    MARK: - Movement
    
    var nextGridPosition: vector_int2 = vector_int2(0, 0) {
        willSet {
            if nextGridPosition != newValue,
            let map = (sprite.scene as? MazeModeScene)?.map {
//                移动到下个节点，设置速度
                let action = SKAction.move(to: map.pointForGridPosition(newValue), duration: durationForDistance(mazeCellWidth))
                let update = SKAction.run({ () -> Void in
                    (self.entity as? Entity)?.gridPosition = newValue
                    if self.secondNextGridPosition != nil {
                        self.nextGridPosition = self.secondNextGridPosition!
                        self.secondNextGridPosition = nil
                    }
                })

                sprite.run(SKAction.sequence([action, update]), withKey: "move")
                
                return
            }
        }
    }
    
    var secondNextGridPosition: vector_int2?
    
    //通过渐变的动画变换位置
    func warpToGridPosition(_ gridPosition: vector_int2) {
        if let map = (sprite.scene as? MazeModeScene)?.map {
            let fadeOut = SKAction.fadeOut(withDuration: 0.5)
            let warp = SKAction.move(to: map.pointForGridPosition(gridPosition), duration:0.5)
            let fadeIn = SKAction.fadeIn(withDuration: 0.5)
            let update = SKAction.run({
                (self.entity as? Entity)?.gridPosition = gridPosition
            })
            
            sprite.run(SKAction.sequence([fadeOut, update, warp, fadeIn]))
        }
    }
    
    func followPath(_ path: [GKGridGraphNode], completion completionHandler: @escaping (Void) -> Void) {
        // Ignore the first node in the path -- it's the starting position.
        let dropFirst = path[1 ..< path.count]
        
        var sequence = [SKAction]()
        
        for node in dropFirst {
            //溃逃回复活点的动画
            if let map = (sprite.scene as? MazeModeScene)?.map {
                let point = map.pointForGridPosition(node.gridPosition)
                sequence.append(SKAction.move(to: point, duration: 0.15))
                sequence.append(SKAction.run({ () -> Void in
                    (self.entity as? Entity)?.gridPosition = node.gridPosition
                }))
            }
        }
        
        sequence.append(SKAction.run(completionHandler))
        sprite.run(SKAction.sequence(sequence))
    }
    
    func durationForDistance(_ distance: CGFloat) -> TimeInterval {
        return TimeInterval(distance / sprite.moveSpeed * 0.7)
    }
}
