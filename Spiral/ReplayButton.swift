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
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)) { () -> Void in
            let gvc = UIApplication.sharedApplication().keyWindow?.rootViewController as! GameViewController
            gvc.startRecordWithHandler { () -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if self.scene is GameScene {
                        Data.sharedData.gameOver = false
                    }
                })
            }
        }
    }

}
