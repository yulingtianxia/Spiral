//
//  GameScene.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-7-12.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import SpriteKit

class GameScene: SKScene ,SKPhysicsContactDelegate{
    var player:Player
    let map:Map
    let display:Display
    let soundManager = SoundManager()
    let background:Background
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    override init(size:CGSize){
        GameKitHelper.sharedGameKitHelper().authenticateLocalPlayer()
        soundManager.playBackGround()
        let center = CGPointMake(size.width/2, size.height/2)
        player = Player()
        map = Map(origin:center, layer: 5, size:size)
        player.position = map.points[player.lineNum]
        display = Display()
        Data.display = display
        background = Background(size: size)
        background.position = center
        
        super.init(size:size)
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self
        self.addChild(background)
        self.addChild(map)
        self.addChild(player)
        self.addChild(display)
        
        display.setPosition()
        player.runInMap(map)
        nodeFactory()
        //Observe Notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("pause"), name: UIApplicationWillResignActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("pause"), name: UIApplicationDidEnterBackgroundNotification, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("resume"), name: UIApplicationWillEnterForegroundNotification, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("resume"), name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        
        
    }
    
//    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
//        for touch:AnyObject in touches{
//            if Data.gameOver {
////                restartGame()
//            }
//            else if view?.paused == true{
//                resume()
//            }
//            else if player.lineNum>3 {
//                calNewLocation()
//                player.removeAllActions()
//                player.jump = true
//                player.runInMap(map)
//                soundManager.playJump()
//            }
//            
//            
//        }
//    }
    
    func tap(){
        if Data.gameOver {
            //                restartGame()
        }
        else if view?.paused == true{
            resume()
        }
        else if player.lineNum>3 {
            calNewLocation()
            player.removeAllActions()
            player.jump = true
            player.runInMap(map)
            soundManager.playJump()
        }
    }
    
    func createReaper(){
        if !Data.gameOver {
            var shape = Reaper()
            if Data.reaperNum>0 {
                Data.reaperNum--
                shape.lineNum = 0
                shape.position = self.map.points[shape.lineNum]
                shape.runInMap(self.map)
                self.addChild(shape)
            }
            
            
        }
    }
    
    func speedUp(){
        for node in self.children{
            if let shape = node as? Shape {
                shape.removeAllActions()
//                shape.moveSpeed += CGFloat(Data.speedScale) * shape.moveSpeed
                shape.moveSpeed += Data.speedScale * shape.speedUpBase
                shape.runInMap(map)
            }
        }
    }
    
    func hideGame(){
        map.alpha = 0.2
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
        background.alpha = 0.5
        Data.restart()
        player.restart(map)
        soundManager.playBackGround()
    }
    
    func calNewLocation(){
        let spacing = map.spacing
        let scale = CGFloat((player.lineNum/4-1)*2+1)/CGFloat(player.lineNum/4*2+1)
        let newDistance = player.calDistanceInMap(map)*scale
        player.lineNum-=4
        player.removeAllActions()
        let nextPoint = map.points[player.lineNum+1]
        switch player.lineNum%4{
        case 0:
            player.position = CGPointMake(nextPoint.x, nextPoint.y+newDistance)
        case 1:
            player.position = CGPointMake(nextPoint.x+newDistance, nextPoint.y)
        case 2:
            player.position = CGPointMake(nextPoint.x, nextPoint.y-newDistance)
        case 3:
            player.position = CGPointMake(nextPoint.x-newDistance, nextPoint.y)
        default:
            println("Why?")
        }
        
    }
    
    func nodeFactory(){
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock({
            if !Data.gameOver {
                let type = arc4random()%UInt32(4)
                var object:AnyObject!
                switch type {
                case 0,1:
                    object = Killer()
                case 2:
                    object = Score()
                case 3:
                    object = Shield()
                default:
                    println(type)
                }
                var shape = object as Shape
                shape.lineNum = 0
                shape.position = self.map.points[shape.lineNum]
                shape.runInMap(self.map)
                self.addChild(shape)
            }
            }),SKAction.waitForDuration(5, withRange: 1)])))
        
        
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
                (child as SKNode).removeAllActions()
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
    func pause() {
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
