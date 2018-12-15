//
//  ZenButton.swift
//  Spiral
//
//  Created by 杨萧玉 on 15/6/4.
//  Copyright (c) 2015年 杨萧玉. All rights reserved.
//

import SpriteKit

class ZenButton: SKSpriteNode {
    let light = SKLightNode()
    init() {
        super.init(texture: SKTexture(imageNamed: "ZenBtn"), color: UIColor.clear, size: mainButtonSize)
        normalTexture = texture?.generatingNormalMap(withSmoothness: 0.2, contrast: 2.5)
        light.categoryBitMask = bgLightCategory
        addChild(light)
        lightingBitMask = playerLightCategory | killerLightCategory | scoreLightCategory | shieldLightCategory | reaperLightCategory
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isUserInteractionEnabled = false
        if !Data.sharedData.gameOver {
            return
        }
        Data.sharedData.currentMode = .zen
        Data.sharedData.gameOver = false
        let gvc = UIApplication.shared.keyWindow?.rootViewController as! GameViewController
        gvc.startRecordWithHandler { () -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                if self.scene is MainScene {
                    gvc.addGestureRecognizers()
                    let scene = ZenModeScene(size: self.scene!.size)
                    let flip = SKTransition.flipHorizontal(withDuration: 1)
                    flip.pausesIncomingScene = false
                    self.scene?.view?.presentScene(scene, transition: flip)
                }
            })
        }
    }
}
