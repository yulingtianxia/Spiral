//
//  OrdinaryButton.swift
//  Spiral
//
//  Created by 杨萧玉 on 15/6/4.
//  Copyright (c) 2015年 杨萧玉. All rights reserved.
//

import SpriteKit

class OrdinaryButton: SKSpriteNode {
    let light = SKLightNode()
    init() {
        super.init(texture: SKTexture(imageNamed: "OrdinaryBtn"), color: UIColor.clearColor(), size: mainButtonSize)
        normalTexture = texture?.textureByGeneratingNormalMapWithSmoothness(0.2, contrast: 2.5)
        light.categoryBitMask = bgLightCategory
        addChild(light)
        lightingBitMask = playerLightCategory | killerLightCategory | scoreLightCategory | shieldLightCategory | reaperLightCategory
        userInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        userInteractionEnabled = false
        if !Data.sharedData.gameOver {
            return
        }
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)) { () -> Void in
            Data.sharedData.currentMode = .Ordinary
            Data.sharedData.gameOver = false
            let gvc = UIApplication.sharedApplication().keyWindow?.rootViewController as! GameViewController
            gvc.startRecordWithHandler { () -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if self.scene is MainScene {
                        gvc.addGestureRecognizers()
                        let scene = OrdinaryModeScene(size: self.scene!.size)
                        let flip = SKTransition.flipHorizontalWithDuration(1)
                        flip.pausesIncomingScene = false
                        self.scene?.view?.presentScene(scene, transition: flip)
                    }
                })
            }
        }
    }
}
