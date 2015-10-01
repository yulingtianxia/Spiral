//
//  MazeModeScene.swift
//  Spiral
//
//  Created by 杨萧玉 on 15/9/29.
//  Copyright © 2015年 杨萧玉. All rights reserved.
//

import SpriteKit
import GameplayKit

//protocol MazeModeSceneDelegate: class, SKSceneDelegate {
//    var hasPowerup: Bool {get set}
//    var playerDirection: PlayerDirection {get set}
//    
//    func scene(scene: MazeModeScene, didMoveToView view: SKView)
//}

class MazeModeScene: SKScene, SKPhysicsContactDelegate {
    
    let map: MazeMap
    var shapes = [Entity]()
    let player: Entity
    var playerDirection: PlayerDirection = .None
    var hasPowerup: Bool = false {
        willSet {
            let powerupDuration: NSTimeInterval = 10
            if newValue != hasPowerup {
                let nextState: AnyClass
                if !hasPowerup {
                    nextState = ShapeFleeState.self
                }
                else {
                    nextState = ShapeChaseState.self
                }
                
                for component in intelligenceSystem.components as! [IntelligenceComponent] {
                    component.stateMachine.enterState(nextState)
                }
                powerupTimeRemaining = powerupDuration
            }
        }
    }
    let random: GKRandomSource
    
    let intelligenceSystem: GKComponentSystem
    var prevUpdateTime: NSTimeInterval = 0
    
    var powerupTimeRemaining: NSTimeInterval = 0 {
        didSet {
            if powerupTimeRemaining < 0 {
                hasPowerup = false
            }
        }
    }
    
    override init(size: CGSize) {
        random = GKRandomSource()
        map = MazeMap()
        
        // Create player entity with display and control components.
        player = Entity()
        player.gridPosition = map.startPosition.gridPosition
        player.addComponent(SpriteComponent(type: .Player))
        player.addComponent(PlayerControlComponent(map: map))
        
        // Create shape entities with display and AI components.
        let types: [ShapeType] = [.Killer, .Score, .Killer, .Shield]
        intelligenceSystem = GKComponentSystem(componentClass: IntelligenceComponent.self)
        
        //TODO: 这里的 size 应该是CGSize(self.level.width * AAPLCellWidth, self.level.height * AAPLCellWidth)
        super.init(size: size)
        
        for (index, node) in map.shapeStartPositions.enumerate() {
            let shape = Entity()
            shape.gridPosition = node.gridPosition
            shape.addComponent(SpriteComponent(type: types[index]))
            shape.addComponent(IntelligenceComponent(scene: self, entity: shape, startingPosition: node))
            intelligenceSystem.addComponentWithEntity(shape)
            shapes.append(shape)
        }
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        
    }
    
    override func update(currentTime: NSTimeInterval) {
        // Track the time delta since the last update.
        if prevUpdateTime < 0 {
            prevUpdateTime = currentTime
        }
        let dt = currentTime - prevUpdateTime
        prevUpdateTime = currentTime
        
        // Track remaining time on the powerup.
        powerupTimeRemaining -= dt
        
        // Update components with the new time delta.
        intelligenceSystem.updateWithDeltaTime(dt)
        player.updateWithDeltaTime(dt)
    }
    
//    MARK: - SKPhysicsContactDelegate
    
    func didBeginContact(contact: SKPhysicsContact) {
        
    }
    
    func pointForGridPosition(position: vector_int2) -> CGPoint {
        return CGPoint(x: position.x * mazeCellWidth + mazeCellWidth / 2, y: position.y * mazeCellWidth  + mazeCellWidth / 2)
    }
}
