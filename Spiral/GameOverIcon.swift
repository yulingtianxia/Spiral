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
        switch Data.sharedData.currentMode {
        case .ordinary:
            imageString = "gameover_ordinary"
        case .zen:
            imageString = "gameover_zen"
        case .maze:
            imageString = "gameover_maze"
        }
        super.init(texture: SKTexture(imageNamed: imageString), color: UIColor.clear, size: size)
        isUserInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        Data.sharedData.display = nil
        Data.sharedData.reset()
        let scene = MainScene(size: self.scene!.size)
        let flip = SKTransition.flipHorizontal(withDuration: 1)
        flip.pausesIncomingScene = false
        self.scene?.view?.presentScene(scene, transition: flip)
    }
}
