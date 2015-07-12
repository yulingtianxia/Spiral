//
//  Replay.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-7-16.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import SpriteKit

class ReplayButton: SKSpriteNode {
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init() {
        let texture = SKTexture(imageNamed: "replaybtn")
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size() * 0.5)
        userInteractionEnabled = true
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        Data.sharedData.gameOver = false
    }

}
