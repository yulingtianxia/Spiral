//
//  GameScene.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-7-12.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import SpriteKit

@objc protocol GameControlProtocol{
    func pause()
    func tap()
    func createReaper()
    func allShapesJumpIn()
    
}
class GameScene: SKScene, SKPhysicsContactDelegate, GameControlProtocol{
    let soundManager = SoundManager()
    var player:Player
    
    override init(size:CGSize){
        player = Player()
        soundManager.playBackGround()
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pause() {
        
    }
    
    func tap() {
        
    }
    
    func createReaper() {
        
    }
    
    func allShapesJumpIn() {
        
    }
    
    //MARK: SKPhysicsContactDelegate
    
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
