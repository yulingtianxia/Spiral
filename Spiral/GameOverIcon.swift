//
//  GameOverIcon.swift
//  Spiral
//
//  Created by 杨萧玉 on 15/6/4.
//  Copyright (c) 2015年 杨萧玉. All rights reserved.
//

import SpriteKit

class GameOverIcon: SKSpriteNode {
    init(size:CGSize) {
        let imageString:String
        switch Data.currentMode {
        case .Ordinary:
            imageString = "gameover_ordinary"
        case .Zen:
            imageString = "gameover_zen"
        }
        super.init(texture: SKTexture(imageNamed: imageString), color: UIColor.clearColor(), size: size)
        userInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        let scene = MainScene(size: self.scene!.size)
        let flip = SKTransition.flipHorizontalWithDuration(1)
        flip.pausesIncomingScene = false
        self.scene?.view?.presentScene(scene, transition: flip)
    }
}
