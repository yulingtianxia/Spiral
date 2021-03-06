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
            case .ordinary:
                imageString = "bg_ordinary"
            case .zen:
                imageString = "bg_zen"
            case .maze:
                imageString = "bg_maze"
            }
        }
        else{
            imageString = imageName!
        }
        
        var resultTexture = SKTexture(imageNamed: imageString)
        if let bgImage = UIImage(named: imageString) {
            let xScale = size.width / bgImage.size.width
            let yScale = size.height / bgImage.size.height
            let scale = max(xScale, yScale)
            let scaleSize = CGSize(width: xScale / scale, height: yScale / scale)
            let scaleOrigin = CGPoint(x: (1 - scaleSize.width) / 2, y: (1 - scaleSize.height) / 2)
            if let cgimage = bgImage.cgImage?.cropping(to: CGRect(origin: CGPoint(x: scaleOrigin.x * bgImage.size.width, y: scaleOrigin.y * bgImage.size.height), size: CGSize(width: scaleSize.width * bgImage.size.width, height: scaleSize.height * bgImage.size.height))) {
                resultTexture = SKTexture(cgImage: cgimage)
            }
        }
        
        
        super.init(texture: resultTexture, color:SKColor.clear, size: size)

        normalTexture = resultTexture.generatingNormalMap(withSmoothness: 0.2, contrast: 2.5)
        zPosition = -100
        alpha = 0.5
        let light = SKLightNode()
        switch Data.sharedData.currentMode {
        case .ordinary:
            light.lightColor = SKColor.black
            light.ambientColor = SKColor.black
        case .zen:
            light.lightColor = SKColor.brown
            light.ambientColor = SKColor.brown
        case .maze:
            light.lightColor = SKColor.black
            light.ambientColor = SKColor.black
        }
        
        light.categoryBitMask = bgLightCategory
        lightingBitMask = playerLightCategory|killerLightCategory|scoreLightCategory|shieldLightCategory|bgLightCategory|reaperLightCategory
        addChild(light)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
