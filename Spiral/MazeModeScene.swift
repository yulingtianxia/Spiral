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
    var playerDirection: PlayerDirection {
        get {
            let component = player.componentForClass(PlayerControlComponent.self)
            return component?.direction ?? .None
        }
        set {
            let component = player.componentForClass(PlayerControlComponent.self)
            component?.attemptedDirection = newValue
        }
    }
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
    
    override init() {
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
        
        super.init(size: CGSize(width: map.width * mazeCellWidth, height: map.height * mazeCellWidth))
        
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
        backgroundColor = SKColor.blackColor()
        
        // Generate maze.
        let maze = SKNode()
        let cellSize = CGSize(width: mazeCellWidth, height: mazeCellWidth)
        let graph = map.pathfindingGraph
        for i in 0 ..< map.width {
            for j in 0 ..< map.height {
                if graph.nodeAtGridPosition(vector_int2(i, j)) != nil {
                    //TODO:  绘制地图：墙和道路
                    let node = SKSpriteNode(color: SKColor.grayColor(), size: cellSize)
                    node.position = pointForGridPosition(vector_int2(i, j))
                    maze.addChild(node)
                }
            }
        }
        addChild(maze)
        
        // Add player entity to scene.
        if let playerComponent = player.componentForClass(SpriteComponent.self) {
            playerComponent.sprite.position = pointForGridPosition(player.gridPosition)
            addChild(playerComponent.sprite)
        }
        
        // Add shape entities to scene.
        for entity in shapes {
            if let shapeComponent = entity.componentForClass(SpriteComponent.self) {
                shapeComponent.sprite.position = pointForGridPosition(entity.gridPosition)
                addChild(shapeComponent.sprite)
            }
        }
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
    
    func pointForGridPosition(position: vector_int2) -> CGPoint {
        return CGPoint(x: position.x * mazeCellWidth + mazeCellWidth / 2, y: position.y * mazeCellWidth  + mazeCellWidth / 2)
    }
    
//    MARK: - SKPhysicsContactDelegate
    
    func didBeginContact(contact: SKPhysicsContact) {
        //A->B
        let visitorA = ContactVisitor.contactVisitorWithBody(contact.bodyA, forContact: contact)
        let visitableBodyB = VisitablePhysicsBody(body: contact.bodyB)
        visitableBodyB.acceptVisitor(visitorA)
        //B->A
        let visitorB = ContactVisitor.contactVisitorWithBody(contact.bodyB, forContact: contact)
        let visitableBodyA = VisitablePhysicsBody(body: contact.bodyA)
        visitableBodyA.acceptVisitor(visitorB)
    }
    
}
