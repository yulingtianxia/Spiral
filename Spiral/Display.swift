//
//  Display.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-7-15.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import SpriteKit
protocol DisplayData{
    func updateData()
}
class Display: SKNode ,DisplayData{
    let scoreLabel = SKLabelNode(text: "SCORE \(Data.score)")
    init(){
        super.init()
        scoreLabel.fontSize = 25
        self.addChild(scoreLabel)
    }
    func setPosition(){
        scoreLabel.position = CGPointMake(CGRectGetMidX(self.scene.frame), CGRectGetMinY(self.scene.frame))
    }
    func updateData() {
        scoreLabel.text = "SCORE \(Data.score)"
    }
}
