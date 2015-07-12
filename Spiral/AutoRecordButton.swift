//
//  AutoRecordButton.swift
//  Spiral
//
//  Created by 杨萧玉 on 15/7/12.
//  Copyright © 2015年 杨萧玉. All rights reserved.
//

import UIKit

class AutoRecordButton: SKSpriteNode {
    init() {
        let texture:SKTexture
        if Data.sharedData.autoRecord {
            texture = SKTexture(imageNamed: "ButtonAutoRecordOn")
        }
        else {
            texture = SKTexture(imageNamed: "ButtonAutoRecordOff")
        }
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size() * 0.5)
        userInteractionEnabled = true
        
        //添加"AUTORECORD"文字
        let auto = SKLabelNode(text: "AUTO")
        let record = SKLabelNode(text: "RECORD")
        auto.fontName = "Menlo Bold"
        record.fontName = "Menlo Bold"
        auto.position = CGPoint(x: size.width / 6, y: 0)
        record.position = CGPoint(x: size.width / 6, y: -size.height / 3)
        auto.fontColor = UIColor.blackColor()
        record.fontColor = UIColor.blackColor()
        auto.fontSize = 12
        record.fontSize = 12
        addChild(auto)
        addChild(record)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if Data.sharedData.autoRecord {
            Data.sharedData.autoRecord = false
            texture = SKTexture(imageNamed: "ButtonAutoRecordOff")
        }
        else {
            Data.sharedData.autoRecord = true
            texture = SKTexture(imageNamed: "ButtonAutoRecordOn")
        }
    }
}
