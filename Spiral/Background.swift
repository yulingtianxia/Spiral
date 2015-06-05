//
//  Background.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-10-10.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import SpriteKit
/**
*  游戏背景绘制
*/
class Background: SKSpriteNode {
    init(size:CGSize, imageName:String?=nil){
        let imageString:String
        if imageName == nil {
            switch Data.currentMode {
            case .Ordinary:
                imageString = "bg_ordinary"
            case .Zen:
                imageString = "bg_zen"
            }
        }
        else{
            imageString = imageName!
        }
        
        super.init(texture: SKTexture(imageNamed: imageString),color:SKColor.clearColor(), size: size)
        normalTexture = texture?.textureByGeneratingNormalMapWithSmoothness(0.2, contrast: 2.5)
        zPosition = -100
        alpha = 0.5
        var light = SKLightNode()
        switch Data.currentMode {
        case .Ordinary:
            light.lightColor = SKColor.blackColor()
            light.ambientColor = SKColor.blackColor()
        case .Zen:
            light.lightColor = SKColor.brownColor()
            light.ambientColor = SKColor.brownColor()
        }
        
        light.categoryBitMask = bgLightCategory
        lightingBitMask = playerLightCategory|killerLightCategory|scoreLightCategory|shieldLightCategory|bgLightCategory|reaperLightCategory
        addChild(light)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
