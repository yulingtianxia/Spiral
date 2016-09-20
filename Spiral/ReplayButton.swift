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
        super.init(texture: texture, color: UIColor.clear, size: texture.size() * 0.5)
        isUserInteractionEnabled = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async { () -> Void in
            let gvc = UIApplication.shared.keyWindow?.rootViewController as! GameViewController
            gvc.startRecordWithHandler { () -> Void in
                DispatchQueue.main.async(execute: { () -> Void in
                    Data.sharedData.gameOver = false
                })
            }
        }
    }

}
