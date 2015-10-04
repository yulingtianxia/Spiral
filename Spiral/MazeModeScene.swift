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
    let soundManager = SoundManager()
    let display: MazeDisplay
    let background:Background
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
        player = Entity()
        player.gridPosition = map.startPosition.gridPosition
        player.addComponent(SpriteComponent(type: .Player))
        player.addComponent(PlayerControlComponent(map: map))
        
        // Create shape entities with display and AI components.
        let types: [ShapeType] = [.Killer, .Score, .Killer, .Shield]
        intelligenceSystem = GKComponentSystem(componentClass: IntelligenceComponent.self)
        
//        CGSize(width: map.width * mazeCellWidth, height: map.height * mazeCellWidth)
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
        
        //Observe Notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("pause"), name: UIApplicationWillResignActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("pause"), name: UIApplicationDidEnterBackgroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("pause"), name: WantGamePauseNotification, object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
        soundManager.stopBackGround()
    }
    
    override func didMoveToView(view: SKView) {
        
        addChild(background)
        addChild(map)
        addChild(display)
        display.setPosition()
        
        
//        play background music
        soundManager.playBackGround()
        addChild(soundManager)
        
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
        
        resume()
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
    
    //MARK: - UI control methods
    
    func tap(){
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
    
    func createReaper(){
        if !Data.sharedData.gameOver && view?.paused == false {
            if Data.sharedData.reaperNum>0 {
                Data.sharedData.reaperNum--
                //TODO: 释放收割机，去收获。。。
            }
        }
    }
    
    func speedUp(){
        for node in children{
            if let shape = node as? Shape {
                shape.removeAllActions()
                shape.moveSpeed += Data.sharedData.speedScale * shape.speedUpBase
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
        enumerateChildNodesWithName("Killer", usingBlock: { (node, stop) -> Void in
            node.removeFromParent()
        })
        enumerateChildNodesWithName("Score", usingBlock: { (node, stop) -> Void in
            node.removeFromParent()
        })
        enumerateChildNodesWithName("Shield", usingBlock: { (node, stop) -> Void in
            node.removeFromParent()
        })
        enumerateChildNodesWithName("Reaper", usingBlock: { (node, stop) -> Void in
            node.removeFromParent()
        })
        map.alpha = 1

        background.alpha = 0.5
        Data.sharedData.reset()
        if let sprite = (player.componentForClass(SpriteComponent.self)?.sprite as? Player) {
            sprite.restart()
            sprite.position = pointForGridPosition(map.startPosition.gridPosition)
        }
        soundManager.playBackGround()
    }
    
    //MARK: pause&resume game
    
    func pause() {
        if !Data.sharedData.gameOver {
            self.runAction(SKAction.runBlock({ [unowned self]() -> Void in
                self.display.pause()
                }), completion: { [unowned self]() -> Void in
                    self.view?.paused = true
                })
        }
    }
    
    func resume() {
        display.resume()
        view?.paused = false
    }

}
