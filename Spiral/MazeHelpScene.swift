//
//  MazeHelpScene.swift
//  Spiral
//
//  Created by 杨萧玉 on 15/10/8.
//  Copyright © 2015年 杨萧玉. All rights reserved.
//

import SpriteKit

class MazeHelpScene: SKScene {
    func lightWithFinger(_ point:CGPoint){
        if let light = self.childNode(withName: "light") as? SKLightNode {
            light.lightColor = SKColor.white
            light.position = self.convertPoint(fromView: point)
        }
    }
    
    func turnOffLight() {
        (self.childNode(withName: "light") as? SKLightNode)?.lightColor = SKColor.black
    }
    
    func back() {
        if !Data.sharedData.gameOver {
            return
        }
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async { () -> Void in
            Data.sharedData.currentMode = .maze
            Data.sharedData.gameOver = false
            Data.sharedData.reset()
            let gvc = UIApplication.shared.keyWindow?.rootViewController as! GameViewController
            gvc.startRecordWithHandler { () -> Void in
                DispatchQueue.main.async(execute: { () -> Void in
                    if self.scene is MazeHelpScene {
                        gvc.addGestureRecognizers()
                        let scene = MazeModeScene(size: self.size)
                        let push = SKTransition.push(with: SKTransitionDirection.right, duration: 1)
                        push.pausesIncomingScene = false
                        self.scene?.view?.presentScene(scene, transition: push)
                    }
                })
            }
        }
    }
    
    override func didMove(to view: SKView) {
        let bg = childNode(withName: "background") as! SKSpriteNode
        let w = bg.size.width
        let h = bg.size.height
        let scale = max(view.frame.width/w, view.frame.height/h)
        bg.xScale = scale
        bg.yScale = scale
    }
}
