//
//  MazeModeScene.swift
//  Spiral
//
//  Created by 杨萧玉 on 15/9/29.
//  Copyright © 2015年 杨萧玉. All rights reserved.
//

import SpriteKit
import GameplayKit

struct Line: Hashable{
    let pa: vector_int2
    let pb: vector_int2
    
    var hashValue: Int {
        get {
            return "\(pa.x),\(pa.y),\(pb.x),\(pb.y)".hashValue
        }
    }
}

typealias line_int4 = Line

class MazeModeScene: GameScene {
    
    let map: MazeMap
    let display: MazeDisplay
    let background:Background
    var shapes = [Entity]()
    var playerEntity: Entity
    var playerDirection: PlayerDirection {
        get {
            let component = playerEntity.componentForClass(PlayerControlComponent.self)
            return component?.direction ?? .None
        }
        set {
            let component = playerEntity.componentForClass(PlayerControlComponent.self)
            component?.attemptedDirection = newValue
        }
    }
    var hasPowerup: Bool = false {
        willSet {
            let powerupDuration: NSTimeInterval = 10
            if newValue != hasPowerup {
                let nextState: AnyClass
                if newValue {
                    nextState = ShapeFleeState.self
                }
                else {
                    (playerEntity.componentForClass(SpriteComponent.self)?.sprite as? Player)?.shield = false
                    nextState = ShapeChaseState.self
                }
                
                for component in intelligenceSystem.components as! [IntelligenceComponent] {
                    if (component.entity as! Entity).shapeType == .Killer {
                        component.stateMachine.enterState(nextState)
                    }
                }
                powerupTimeRemaining = powerupDuration
            }
        }
    }
    let random: GKRandomSource
    
    var intelligenceSystem: GKComponentSystem
    var prevUpdateTime: NSTimeInterval = 0
    
    var powerupTimeRemaining: NSTimeInterval = 0 {
        didSet {
            if powerupTimeRemaining < 0 {
                hasPowerup = false
            }
        }
    }
    
    var pathCache = [line_int4:[GKGridGraphNode]]()
    
    override init(size: CGSize) {
        random = GKRandomSource()
        GameKitHelper.sharedGameKitHelper.authenticateLocalPlayer()
        Data.sharedData.currentMode = .Maze
        let center = CGPointMake(size.width/2, size.height/2)
        map = MazeMap(size: size)
        display = MazeDisplay()
        Data.sharedData.display = display
        background = Background(size: size)
        background.position = center
        
        // Create player entity with display and control components.
        playerEntity = Entity(type: .Player)
        playerEntity.gridPosition = map.startPosition.gridPosition
        playerEntity.addComponent(SpriteComponent(entity: playerEntity))
        playerEntity.addComponent(PlayerControlComponent(map: map))
        
        // Create shape entities with display and AI components.
        let types: [ShapeType] = [.Killer, .Score, .Shield, .Killer]
        intelligenceSystem = GKComponentSystem(componentClass: IntelligenceComponent.self)
        
        super.init(size: size)
        
        for (index, node) in map.shapeStartPositions.enumerate() {
            let shape = Entity(type: types[index])
            shape.gridPosition = node.gridPosition
            shape.addComponent(SpriteComponent(entity: shape))
            shape.addComponent(IntelligenceComponent(scene: self, entity: shape, startingPosition: node))
            intelligenceSystem.addComponentWithEntity(shape)
            shapes.append(shape)
        }
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        //Observe Notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GameControlProtocol.pause), name: UIApplicationWillResignActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GameControlProtocol.pause), name: UIApplicationDidEnterBackgroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GameControlProtocol.pause), name: WantGamePauseNotification, object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
        soundManager.stopBackGround()
    }
    
    func resetShapes() {
        
        //clean shapes
        if let playerComponent = playerEntity.componentForClass(SpriteComponent.self) {
            playerComponent.sprite.removeFromParent()
        }
        for entity in shapes {
            if let shapeComponent = entity.componentForClass(SpriteComponent.self) {
                shapeComponent.sprite.removeFromParent()
            }
        }
        
        // Create player entity with display and control components.
        playerEntity = Entity(type: .Player)
        playerEntity.gridPosition = map.startPosition.gridPosition
        playerEntity.addComponent(SpriteComponent(entity: playerEntity))
        playerEntity.addComponent(PlayerControlComponent(map: map))
        
        
        // Create shape entities with display and AI components.
        let types: [ShapeType] = [.Killer, .Score, .Shield, .Killer]
        intelligenceSystem = GKComponentSystem(componentClass: IntelligenceComponent.self)
        
        shapes.removeAll()
        for (index, node) in map.shapeStartPositions.enumerate() {
            let shape = Entity(type: types[index])
            shape.gridPosition = node.gridPosition
            shape.addComponent(SpriteComponent(entity: shape))
            shape.addComponent(IntelligenceComponent(scene: self, entity: shape, startingPosition: node))
            intelligenceSystem.addComponentWithEntity(shape)
            shapes.append(shape)
        }
        
        // Add player entity to scene.
        if let playerComponent = playerEntity.componentForClass(SpriteComponent.self) {
            player = playerComponent.sprite as! Player
            playerComponent.sprite.position = map.pointForGridPosition(playerEntity.gridPosition)
            addChild(playerComponent.sprite)
        }
        
        // Add shape entities to scene.
        for entity in shapes {
            if let shapeComponent = entity.componentForClass(SpriteComponent.self) {
                shapeComponent.sprite.position = map.pointForGridPosition(entity.gridPosition)
                addChild(shapeComponent.sprite)
            }
        }
    }
    
    override func didMoveToView(view: SKView) {
        
        addChild(background)
        addChild(map)
        addChild(display)
        display.setPosition()
        
        // Add player entity to scene.
        if let playerComponent = playerEntity.componentForClass(SpriteComponent.self) {
            player = playerComponent.sprite as! Player
            playerComponent.sprite.position = map.pointForGridPosition(playerEntity.gridPosition)
            addChild(playerComponent.sprite)
        }
        
        // Add shape entities to scene.
        for entity in shapes {
            if let shapeComponent = entity.componentForClass(SpriteComponent.self) {
                shapeComponent.sprite.position = map.pointForGridPosition(entity.gridPosition)
                addChild(shapeComponent.sprite)
            }
        }
        
        resume()
    }
    
    override func update(currentTime: NSTimeInterval) {
        if Data.sharedData.gameOver {
            return
        }
        // Track the time delta since the last update.
        if prevUpdateTime < 0 {
            prevUpdateTime = currentTime
        }
        let dt = currentTime - prevUpdateTime
        prevUpdateTime = currentTime
        
        // Track remaining time on the powerup.
        powerupTimeRemaining -= dt
        
        // Update components with the new time delta.
        playerEntity.updateWithDeltaTime(dt)
        intelligenceSystem.updateWithDeltaTime(dt)
    }
    
    //MARK: - UI control methods
    
    override func tap(){
        if Data.sharedData.gameOver {
            //                restartGame()
        }
        else if view?.paused == true{
            resume()
        }
        else {
            soundManager.playJump()
        }
    }
    
    override func createReaper(){
        if !Data.sharedData.gameOver && view?.paused == false {
            if Data.sharedData.reaperNum>0 {
                Data.sharedData.reaperNum -= 1
                // 释放收割机，去收获。。。
                let reaper = Entity(type: .Reaper)
                reaper.gridPosition = playerEntity.gridPosition
                reaper.addComponent(SpriteComponent(entity: reaper))
                reaper.addComponent(IntelligenceComponent(scene: self, entity: reaper, startingPosition: map.pathfindingGraph.nodeAtGridPosition(reaper.gridPosition)!))
                intelligenceSystem.addComponentWithEntity(reaper)
                if let reaperComponent = reaper.componentForClass(SpriteComponent.self) {
                    reaperComponent.sprite.position = map.pointForGridPosition(reaper.gridPosition)
                    addChild(reaperComponent.sprite)
                }
            }
        }
    }
    
    func hideGame(){
        map.alpha = 0.2

        background.alpha = 0.2
        for node in children{
            if let shape = node as? Shape {
                shape.alpha = 0.2
            }
        }
        soundManager.pauseBackGround()
    }
    
    func showGame(){
        map.alpha = 1

        background.alpha = 0.5
        for node in children{
            if let shape = node as? Shape {
                shape.alpha = 1
            }
        }
        soundManager.resumeBackGround()
    }
    
    func restartGame(){
//        for (index, entity) in shapes.enumerate() {
//            if let shapeComponent = entity.componentForClass(SpriteComponent.self) {
//                shapeComponent.warpToGridPosition(map.shapeStartPositions[index].gridPosition)
//                
//            }
//        }
//        
//        if let spriteComponent = playerEntity.componentForClass(SpriteComponent.self) {
//            (spriteComponent.sprite as? Player)?.restart()
//            spriteComponent.warpToGridPosition(map.startPosition.gridPosition)
//        }
        
        resetShapes()
        
        map.alpha = 1

        background.alpha = 0.5
        Data.sharedData.reset()
        
        soundManager.playBackGround()
    }
    
    //MARK: pause&resume game
    
    override func pause() {
        if !Data.sharedData.gameOver {
            self.runAction(SKAction.runBlock({ [unowned self]() -> Void in
                self.display.pause()
                }), completion: { [unowned self]() -> Void in
                    self.view?.paused = true
                })
        }
    }
    
    override func resume() {
        display.resume()
        view?.paused = false
    }

}
