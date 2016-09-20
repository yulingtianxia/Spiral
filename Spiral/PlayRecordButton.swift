//
//  PlayRecordButton.swift
//  Spiral
//
//  Created by 杨萧玉 on 15/7/11.
//  Copyright © 2015年 杨萧玉. All rights reserved.
//

import SpriteKit

class PlayRecordButton: SKSpriteNode {
    init() {
        let texture = SKTexture(imageNamed: "playrecordbtn")
        super.init(texture: texture, color: UIColor.clear, size: texture.size() * 0.5)
        isUserInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        (UIApplication.shared.keyWindow?.rootViewController as! GameViewController).playRecord()
    }
    
}
