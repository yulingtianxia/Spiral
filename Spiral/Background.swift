//
//  Background.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-10-10.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import SpriteKit

class Background: SKSpriteNode {
    init(size:CGSize){
        super.init(texture: SKTexture(imageNamed: "bg"),color:SKColor.clearColor(), size: size)
        self.normalTexture = self.texture?.textureByGeneratingNormalMapWithSmoothness(0, contrast: 0.8)
        self.zPosition = -100
        self.alpha = 0.5
        var light = SKLightNode()
        light.lightColor = SKColor.blackColor()
        light.ambientColor = SKColor.blackColor()
        light.categoryBitMask = bgLightCategory
        self.lightingBitMask = playerLightCategory|killerLightCategory|scoreLightCategory|shieldLightCategory|bgLightCategory|reaperLightCategory
        self.addChild(light)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
