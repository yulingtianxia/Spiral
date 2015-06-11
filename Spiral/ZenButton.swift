//
//  ZenButton.swift
//  Spiral
//
//  Created by 杨萧玉 on 15/6/4.
//  Copyright (c) 2015年 杨萧玉. All rights reserved.
//

import SpriteKit

class ZenButton: SKSpriteNode {
    init() {
        super.init(texture: SKTexture(imageNamed: "ZenBtn"), color: UIColor.clearColor(), size: mainButtonSize)
        normalTexture = texture?.textureByGeneratingNormalMapWithSmoothness(0.2, contrast: 2.5)
        lightingBitMask = playerLightCategory | killerLightCategory | scoreLightCategory | shieldLightCategory | reaperLightCategory
        userInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        Data.sharedData.currentMode = .Zen
        Data.sharedData.gameOver = false
        let scene = ZenModeScene(size: self.scene!.size)
        let flip = SKTransition.flipHorizontalWithDuration(1)
        flip.pausesIncomingScene = false
        (UIApplication.sharedApplication().keyWindow?.rootViewController as! GameViewController).addGestureRecognizers()
        self.scene?.view?.presentScene(scene, transition: flip)
    }
}
