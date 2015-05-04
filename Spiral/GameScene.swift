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
}
