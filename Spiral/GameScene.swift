//
//  GameScene.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-7-12.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import SpriteKit

class GameScene: SKScene ,SKPhysicsContactDelegate{
    let player:Player
    let map:Map
    var gameOver = false
    init(size:CGSize){
        let center = CGPointMake(size.width/2, size.height/2)
        player = Player()
        map = Map(origin:center, layer: 5)
        player.lineNum = 3
        super.init(size:size)
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self
        self.addChild(map)
        self.addChild(player)
        player.runInMap(map)
        nodeFactory()
    }
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        
        
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        for touch:AnyObject in touches{
            let location = touch.locationInNode(self)
            if player.lineNum>3 && !gameOver {
                calNewLocation()
                player.runInMap(map)
            }
            
        }
    }
    
    func calNewLocation(){
        let spacing = map.spacing
        let scale = CGFloat((player.lineNum/4-1)*2+1)/CGFloat(player.lineNum/4*2+1)
        let newDistance = player.calDistanceInMap(map)*scale
        player.lineNum-=4
        player.removeAllActions()
        let nextPoint = map.points[player.lineNum]
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
            let type = arc4random()%UInt32(2)
            var object:AnyObject!
            switch type {
            case 0:
                object = Killer()
            case 1:
                object = Score()
            default:
                println(type)
            }
            var shape = object as Shape
            shape.lineNum = Int(arc4random()%UInt32(5))
            shape.runInMap(self.map)
            self.addChild(shape)
            }),SKAction.waitForDuration(1, withRange: 0.1)])))
        
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    //    #pragma mark SKPhysicsContactDelegate
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
    
}
