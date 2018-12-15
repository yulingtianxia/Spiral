//
//  ZenModeScene.swift
//  Spiral
//
//  Created by 杨萧玉 on 15/5/1.
//  Copyright (c) 2015年 杨萧玉. All rights reserved.
//

import SpriteKit

class ZenModeScene: GameScene {
    let map:ZenMap
    let display:ZenDisplay
    let background:Background
    var nextShapeName = "Killer"
    let nextShape: SKSpriteNode
    let eyes = [Eye(), Eye(), Eye(), Eye()]
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(size:CGSize){
        GameKitHelper.sharedGameKitHelper.authenticateLocalPlayer()
        Data.sharedData.currentMode = .zen
        let center = CGPoint(x: size.width/2, y: size.height/2)
        map = ZenMap(origin:center, layer: 5, size:size)
        
        display = ZenDisplay()
        Data.sharedData.display = display
        background = Background(size: size)
        background.position = center
        nextShape = SKSpriteNode(imageNamed: "killer")
        nextShape.size = CGSize(width: 50, height: 50)
        nextShape.position = map.points[.right]![0]
        nextShape.physicsBody = nil
        nextShape.alpha = 0.4
        nextShape.zPosition = 100
        super.init(size:size)
        player.position = map.points[player.pathOrientation]![player.lineNum]
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        addChild(background)
        addChild(map)
        addChild(player)
        addChild(display)
        addChild(nextShape)
        for (i,eye) in eyes.enumerated() {
            eye.zPosition = 100
            eye.position = map.points[PathOrientation(rawValue: i)!]!.last!
            addChild(eye)
            eye.lookAtNode(player)
        }
        display.setPosition()
        player.runInZenMap(map)
        nodeFactory()
        
        resume()
        
        //Observe Notification
        NotificationCenter.default.addObserver(self, selector: #selector(GameControlProtocol.pause), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GameControlProtocol.pause), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GameControlProtocol.pause), name: NSNotification.Name(rawValue: WantGamePauseNotification), object: nil)
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
        soundManager.stopBackGround()
    }
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        
        
    }
    
    //MARK: - UI control methods
    
    override func tap(){
        super.tap()
        if Data.sharedData.gameOver {
            //                restartGame()
        }
        else if view?.isPaused == true{
            resume()
        }
        else if player.lineNum>0{
            calNewLocationOfShape(player)
            player.runInZenMap(map)
            soundManager.playJump()
        }
    }
    
    override func allShapesJumpIn(){
        super.allShapesJumpIn()
        if !Data.sharedData.gameOver && view?.isPaused == false {
            for node in children {
                if let shape = node as? Shape {
                    if shape.lineNum>0 {
                        calNewLocationOfShape(shape)
                        shape.runInZenMap(map)
                    }
                }
            }
            soundManager.playJump()
        }
    }
    
    override func createReaper(){
        super.createReaper()
        if !Data.sharedData.gameOver && view?.isPaused == false {
            if Data.sharedData.reaperNum>0 {
                Data.sharedData.reaperNum -= 1
                for pathNum in 0...3 {
                    let shape = Reaper()
                    shape.lineNum = 0
                    shape.pathOrientation = PathOrientation(rawValue: pathNum)!
                    shape.position = self.map.points[shape.pathOrientation]![shape.lineNum]
                    shape.runInZenMap(map)
                    self.addChild(shape)
                }
            }
        }
    }
    
    func speedUp(){
        for node in children{
            if let shape = node as? Shape {
                shape.removeAllActions()
                shape.moveSpeed += Data.sharedData.speedScale * shape.speedUpBase
                shape.runInZenMap(map)
            }
        }
    }
    
    func hideGame(){
        map.alpha = 0.2
        for eye in eyes {
            eye.alpha = 0.2
        }
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
        for eye in eyes {
            eye.alpha = 1
        }
        background.alpha = 0.5
        for node in children{
            if let shape = node as? Shape {
                shape.alpha = 1
            }
        }
        soundManager.resumeBackGround()
    }
    
    func restartGame(){
        enumerateChildNodes(withName: "Killer", using: { (node, stop) -> Void in
            node.removeFromParent()
        })
        enumerateChildNodes(withName: "Score", using: { (node, stop) -> Void in
            node.removeFromParent()
        })
        enumerateChildNodes(withName: "Shield", using: { (node, stop) -> Void in
            node.removeFromParent()
        })
        enumerateChildNodes(withName: "Reaper", using: { (node, stop) -> Void in
            node.removeFromParent()
        })
        map.alpha = 1
        for eye in eyes {
            eye.alpha = 1
            if eye.parent == nil {
                addChild(eye)
            }
        }
        background.alpha = 0.5
        Data.sharedData.reset()
        player.restart()
        player.position = map.points[player.pathOrientation]![player.lineNum]
        nodeFactory()
        player.runInZenMap(map)
        soundManager.playBackGround()
    }
    
    //MARK: help methods
    
    func calNewLocationOfShape(_ shape:Shape){
        if shape.lineNum == 0 {
            return
        }

        let scale = CGFloat(shape.lineNum-1)/CGFloat(shape.lineNum)
        let newDistance = shape.calDistanceInZenMap(map)*scale
        shape.lineNum -= 1
        shape.pathOrientation = PathOrientation(rawValue: (shape.pathOrientation.rawValue + 1)%4)!
        shape.removeAllActions()
        let nextPoint = map.points[shape.pathOrientation]![shape.lineNum+1]
        switch (shape.lineNum + shape.pathOrientation.rawValue)%4{
        case 0:
            //go right
            shape.position = CGPoint(x: nextPoint.x-newDistance, y: nextPoint.y)
        case 1:
            //go down
            shape.position = CGPoint(x: nextPoint.x, y: nextPoint.y+newDistance)
        case 2:
            //go left
            shape.position = CGPoint(x: nextPoint.x+newDistance, y: nextPoint.y)
        case 3:
            //go up
            shape.position = CGPoint(x: nextPoint.x, y: nextPoint.y-newDistance)
        default:
            print("Why?", terminator: "")
        }
        if shape.lineNum == 0 {
            shape.lineNum += 1
        }
    }
    
    func nodeFactory(){
        let createNextShape = SKAction.run({
            if !Data.sharedData.gameOver {
                
                let type = arc4random_uniform(4)
                switch type {
                case 0,1:
                    self.nextShapeName = "Killer"
                    self.nextShape.texture = SKTexture(imageNamed: "killer")
                case 2:
                    self.nextShapeName = "Score"
                    self.nextShape.texture = SKTexture(imageNamed: "score")
                case 3:
                    self.nextShapeName = "Shield"
                    self.nextShape.texture = SKTexture(imageNamed: "shield")
                default:
                    self.nextShapeName = "Killer"
                    self.nextShape.texture = SKTexture(imageNamed: "killer")
                    print(type, terminator: "")
                }
                self.nextShape.setScale(1)
            }
        })
        let scale = SKAction.scale(to: 0.4, duration: 5)
        let run = SKAction.run({ () -> Void in
            if !Data.sharedData.gameOver {
                var shape:Shape
                switch self.nextShapeName {
                case "Killer":
                    shape = Killer()
                case "Score":
                    shape = Score()
                case "Shield":
                    shape = Shield()
                default:
                    print(self.nextShapeName, terminator: "")
                    shape = Killer()
                }
                shape.lineNum = 0
                shape.position = self.map.points[shape.pathOrientation]![shape.lineNum]
                shape.runInZenMap(self.map)
                self.addChild(shape)
            }
        })
        let sequenceAction = SKAction.sequence([createNextShape, scale, run])
        let repeatAction = SKAction.repeatForever(sequenceAction)
        nextShape.run(repeatAction)
    }
    
    //MARK: lifecycle callback
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
    }
    
    override func didSimulatePhysics() {

    }
    
    //MARK: pause&resume game
    
    override func pause() {
        super.pause()
        if !Data.sharedData.gameOver {
            self.run(SKAction.run({ [unowned self]() -> Void in
                self.display.pause()
                }), completion: { [unowned self]() -> Void in
                    self.view?.isPaused = true
                })
        }
    }
    
    override func resume() {
        display.resume()
        view?.isPaused = false
    }
}
