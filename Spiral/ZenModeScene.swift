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
    let nextShape = SKSpriteNode(imageNamed: "killer")
//    let eye = Eye()
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(size:CGSize){
        GameKitHelper.sharedGameKitHelper().authenticateLocalPlayer()
        let center = CGPointMake(size.width/2, size.height/2)
        map = ZenMap(origin:center, layer: 5, size:size)
        
        display = ZenDisplay()
        Data.display = display
        background = Background(size: size)
        background.position = center
        nextShape.size = CGSize(width: 50, height: 50)
        nextShape.position = self.map.points[.right]![0]
        nextShape.physicsBody = nil
        nextShape.alpha = 0.4
//        eye.position = map.points.last! as CGPoint
        super.init(size:size)
        player.position = map.points[player.pathOrientation]![player.lineNum]
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        addChild(background)
        addChild(map)
        addChild(player)
        addChild(display)
        addChild(nextShape)
//        addChild(eye)
//        eye.lookAtNode(player)
        display.setPosition()
        player.runInZenMap(map)
        nodeFactory()
        //Observe Notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("pause"), name: UIApplicationWillResignActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("pause"), name: UIApplicationDidEnterBackgroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("pause"), name: WantGamePauseNotification, object: nil)
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        
        
    }
    
    
    override func tap(){
        if Data.gameOver {
            //                restartGame()
        }
        else if view?.paused == true{
            resume()
        }
        else if player.lineNum>0{
            calNewLocationOfShape(player)
            player.runInZenMap(map)
            soundManager.playJump()
        }
    }
    
    override func allShapesJumpIn(){
        if !Data.gameOver && view?.paused == false {
            for node in self.children {
                if let shape = node as? Shape {
                    if shape.lineNum>3 {
                        calNewLocationOfShape(shape)
                        shape.runInZenMap(map)
                    }
                }
            }
            soundManager.playJump()
        }
    }
    
    func speedUp(){
        for node in self.children{
            if let shape = node as? Shape {
                shape.removeAllActions()
                shape.moveSpeed += Data.speedScale * shape.speedUpBase
                shape.runInZenMap(map)
            }
        }
    }
    
    func hideGame(){
        map.alpha = 0.2
//        eye.alpha = 0.2
        background.alpha = 0.2
        for node in self.children{
            if let shape = node as? Shape {
                shape.alpha = 0.2
            }
        }
        soundManager.stopBackGround()
    }
    
    func showGame(){
        map.alpha = 1
//        eye.alpha = 1
        background.alpha = 0.5
        for node in self.children{
            if let shape = node as? Shape {
                shape.alpha = 1
            }
        }
        soundManager.playBackGround()
    }
    
    func restartGame(){
        for node in self.children{
            if let shape = node as? Shape {
                if shape.name=="Killer"||shape.name=="Score"||shape.name=="Shield"||shape.name=="Reaper" {
                    shape.removeFromParent()
                }
            }
            
        }
        map.alpha = 1
//        eye.alpha = 1
//        if eye.parent == nil {
//            addChild(eye)
//        }
        background.alpha = 0.5
        Data.restart()
        player.restart()
        player.position = map.points[player.pathOrientation]![player.lineNum]
        player.runInZenMap(map)
        soundManager.playBackGround()
    }
    
    func calNewLocationOfShape(shape:Shape){
        if shape.lineNum == 0 {
            return
        }
        let spacing = map.spacing
        let scale = CGFloat(shape.lineNum-1)/CGFloat(shape.lineNum)
        let newDistance = shape.calDistanceInZenMap(map)*scale
        shape.lineNum--
        shape.pathOrientation = PathOrientation(rawValue: (shape.pathOrientation.rawValue + 1)%4)!
        shape.removeAllActions()
        let nextPoint = map.points[shape.pathOrientation]![shape.lineNum+1]
        switch (shape.lineNum + shape.pathOrientation.rawValue)%4{
        case 0:
            //go right
            shape.position = CGPointMake(nextPoint.x-newDistance, nextPoint.y)
        case 1:
            //go down
            shape.position = CGPointMake(nextPoint.x, nextPoint.y+newDistance)
        case 2:
            //go left
            shape.position = CGPointMake(nextPoint.x+newDistance, nextPoint.y)
        case 3:
            //go up
            shape.position = CGPointMake(nextPoint.x, nextPoint.y-newDistance)
        default:
            println("Why?")
        }
        if shape.lineNum == 0 {
            shape.lineNum++
        }
    }
    
    func nodeFactory(){
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock({
            if !Data.gameOver {
                
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
                    println(type)
                }
                
            }
        }),SKAction.group([SKAction.waitForDuration(5, withRange: 0),SKAction.runBlock({ () -> Void in
            self.nextShape.runAction(SKAction.scaleTo(0.4, duration: 5), completion: { () -> Void in
                self.nextShape.setScale(1)
            })
        })]),SKAction.runBlock({ () -> Void in
            if !Data.gameOver {
                var shape:Shape
                switch self.nextShapeName {
                case "Killer":
                    shape = Killer()
                case "Score":
                    shape = Score()
                case "Shield":
                    shape = Shield()
                default:
                    println(self.nextShapeName)
                    shape = Killer()
                }
                shape.lineNum = 0
                shape.position = self.map.points[shape.pathOrientation]![shape.lineNum]
                shape.runInZenMap(self.map)
                self.addChild(shape)
            }
        })])))
        
        
    }
    
    func imageWithView(view:UIView)->UIImage{
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
        view.drawViewHierarchyInRect(view.bounds,afterScreenUpdates:true)
        let img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return img;
    }
    
    
    func imageFromNode(node:SKNode)->UIImage{
        let tex = self.scene!.view!.textureFromNode(node)
        let view  = SKView(frame: CGRectMake(0, 0, tex.size().width, tex.size().height))
        let scene = SKScene(size: tex.size())
        let sprite  = SKSpriteNode(texture: tex)
        sprite.position = CGPointMake( CGRectGetMidX(view.frame), CGRectGetMidY(view.frame) );
        scene.addChild(sprite)
        view.presentScene(scene)
        return self.imageWithView(view)
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }
    
    override func didSimulatePhysics() {
        if Data.gameOver {
            for child in self.children{
                (child as! SKNode).removeAllActions()
            }
        }
    }
    
    //pragma mark SKPhysicsContactDelegate
    func didBeginContact(contact:SKPhysicsContact){
        //A->B
        let visitorA = ContactVisitor.contactVisitorWithBody(contact.bodyA, forContact: contact)
        let visitableBodyB = VisitablePhysicsBody(body: contact.bodyB)
        visitableBodyB.acceptVisitor(visitorA)
        //B->A
        let visitorB = ContactVisitor.contactVisitorWithBody(contact.bodyB, forContact: contact)
        let visitableBodyA = VisitablePhysicsBody(body: contact.bodyA)
        visitableBodyA.acceptVisitor(visitorB)
    }
    
    //pause&resume game
    override func pause() {
        if !Data.gameOver{
            self.runAction(SKAction.runBlock({ [unowned self]() -> Void in
                self.display.pause()
                self.soundManager.pauseBackGround()
                }), completion: { [unowned self]() -> Void in
                    self.view!.paused = true
                })
        }
    }
    
    func resume() {
        soundManager.resumeBackGround()
        display.resume()
        view?.paused = false
    }
}
