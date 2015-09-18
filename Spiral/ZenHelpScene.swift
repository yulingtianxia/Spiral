//
//  ZenHelpScene.swift
//  Spiral
//
//  Created by 杨萧玉 on 15/5/3.
//  Copyright (c) 2015年 杨萧玉. All rights reserved.
//

import SpriteKit

class ZenHelpScene: SKScene {
    func lightWithFinger(point:CGPoint){
        if let light = self.childNodeWithName("light") as? SKLightNode {
            light.lightColor = SKColor.whiteColor()
            light.position = self.convertPointFromView(point)
        }
    }
    
    func turnOffLight() {
        (self.childNodeWithName("light") as? SKLightNode)?.lightColor = SKColor.brownColor()
    }
    
    func back() {
        if !Data.sharedData.gameOver {
            return
        }
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)) { () -> Void in
            Data.sharedData.currentMode = .Zen
            Data.sharedData.gameOver = false
            let gvc = UIApplication.sharedApplication().keyWindow?.rootViewController as! GameViewController
            gvc.startRecordWithHandler { () -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if self.scene is ZenHelpScene {
                        gvc.addGestureRecognizers()
                        let scene = ZenModeScene(size: self.size)
                        let push = SKTransition.pushWithDirection(SKTransitionDirection.Right, duration: 1)
                        push.pausesIncomingScene = false
                        self.scene?.view?.presentScene(scene, transition: push)
                    }
                })
            }
        }
    }
    
    override func didMoveToView(view: SKView) {
        let bg = childNodeWithName("background") as! SKSpriteNode
        let w = bg.size.width
        let h = bg.size.height
        let scale = max(view.frame.width/w, view.frame.height/h)
        bg.xScale = scale
        bg.yScale = scale
    }
}
