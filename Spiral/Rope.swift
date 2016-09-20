//
//  Rope.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-10-11.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import SpriteKit

class Rope: SKSpriteNode {
    let maxLength:CGFloat
    let fixWidth:CGFloat = 5
    init(length:CGFloat) {
        
        let texture = SKTexture(imageNamed: "rope")
        maxLength = texture.size().height / (texture.size().width / fixWidth)
        let size = CGSize(width: fixWidth, height: min(length,maxLength))
        super.init(texture: SKTexture(rect: CGRect(origin: CGPoint.zero, size: CGSize(width: 1, height: min(length / maxLength, 1))), in: texture),color:SKColor.clear, size: size)
//        normalTexture = texture?.textureByGeneratingNormalMapWithSmoothness(0.5, contrast: 0.5)
//        lightingBitMask = playerLightCategory|killerLightCategory|scoreLightCategory|shieldLightCategory|reaperLightCategory
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
