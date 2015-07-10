//
//  Replay.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-7-16.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import SpriteKit

class ReplayButton: SKLabelNode {
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    override init() {
        super.init()
        self.userInteractionEnabled = true
        setDefaultFont()
        self.text = NSLocalizedString("REPLAY", comment: "")
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        Data.sharedData.gameOver = false
    }

}
