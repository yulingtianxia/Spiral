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
            switch Data.sharedData.currentMode {
            case .Ordinary:
                imageString = "bg_ordinary"
            case .Zen:
                imageString = "bg_zen"
            case .Maze:
                imageString = "bg_maze"
            }
        }
        else{
            imageString = imageName!
        }
        
        //TODO: 背景纹理调节比例
        var bgTexture = SKTexture(imageNamed: imageString)
        let xScale = size.width / bgTexture.size().width
        let yScale = size.height / bgTexture.size().height
        let scale = max(xScale, yScale)
        let fitRect = CGRect(origin: CGPointZero, size: CGSize(width: xScale / scale, height: yScale / scale))
        bgTexture = SKTexture(rect: fitRect, inTexture: bgTexture)
        
        super.init(texture: bgTexture,color:SKColor.clearColor(), size: size)
        
        normalTexture = texture?.textureByGeneratingNormalMapWithSmoothness(0.2, contrast: 2.5)
        zPosition = -100
        alpha = 0.5
        let light = SKLightNode()
        switch Data.sharedData.currentMode {
        case .Ordinary:
            light.lightColor = SKColor.blackColor()
            light.ambientColor = SKColor.blackColor()
        case .Zen:
            light.lightColor = SKColor.brownColor()
            light.ambientColor = SKColor.brownColor()
        case .Maze:
            light.lightColor = SKColor.blackColor()
            light.ambientColor = SKColor.blackColor()
        }
        
        light.categoryBitMask = bgLightCategory
        lightingBitMask = playerLightCategory|killerLightCategory|scoreLightCategory|shieldLightCategory|bgLightCategory|reaperLightCategory
        addChild(light)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
