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
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size() * 0.5)
        userInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        (UIApplication.sharedApplication().keyWindow?.rootViewController as! GameViewController).playRecord()
    }
    
}
