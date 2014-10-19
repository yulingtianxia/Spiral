//
//  HelpScene.swift
//  Spiral
//
//  Created by 杨萧玉 on 14/10/19.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import SpriteKit

class HelpScene: SKScene {

    func lightWithFinger(point:CGPoint){
        if let light = self.childNodeWithName("light") as? SKLightNode {
            light.lightColor = SKColor.greenColor()
            light.position = self.convertPointFromView(point)
        }
    }
    
    func turnOffLight() {
        (self.childNodeWithName("light") as? SKLightNode)?.lightColor = SKColor.blackColor()
    }
}
