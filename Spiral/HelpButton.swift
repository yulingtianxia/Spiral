//
//  HelpButton.swift
//  Spiral
//
//  Created by 杨萧玉 on 14/10/19.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import SpriteKit

class HelpButton: SKSpriteNode {
    init() {
        let imageString:String
        switch Data.sharedData.currentMode {
        case .Ordinary:
            imageString = "help_ordinary"
        case .Zen:
            imageString = "help_zen"
        case .Maze:
            imageString = "help_maze"
        }
        super.init(texture: SKTexture(imageNamed: imageString), color: SKColor.clearColor(), size: CGSize(width: 40, height: 40))
        userInteractionEnabled = true
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let loading = SKSpriteNode(imageNamed: "loading")
        loading.position = CGPoint(x: CGRectGetMidX(self.scene!.frame), y: CGRectGetMidY(self.scene!.frame))
        loading.zPosition = 150
        self.scene?.addChild(loading)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
            Data.sharedData.display = nil
            (self.parent as? DisplayData)?.disableButtons()
            switch Data.sharedData.currentMode {
            case .Ordinary:
                if let scene = OrdinaryHelpScene.unarchiveFromFile("OrdinaryHelpScene") as? OrdinaryHelpScene {
                    loading.removeFromParent()
                    let crossFade = SKTransition.crossFadeWithDuration(2)
                    crossFade.pausesIncomingScene = false
                    self.scene?.view?.presentScene(scene, transition: crossFade)
                    (UIApplication.sharedApplication().keyWindow?.rootViewController as! GameViewController).addGestureRecognizers()
                }
            case .Zen:
                if let scene = ZenHelpScene.unarchiveFromFile("ZenHelpScene") as? ZenHelpScene {
                    loading.removeFromParent()
                    let crossFade = SKTransition.crossFadeWithDuration(2)
                    crossFade.pausesIncomingScene = false
                    self.scene?.view?.presentScene(scene, transition: crossFade)
                    (UIApplication.sharedApplication().keyWindow?.rootViewController as! GameViewController).addGestureRecognizers()
                }
            case .Maze:
                if let scene = MazeHelpScene.unarchiveFromFile("MazeHelpScene") as? ZenHelpScene {
                    loading.removeFromParent()
                    let crossFade = SKTransition.crossFadeWithDuration(2)
                    crossFade.pausesIncomingScene = false
                    self.scene?.view?.presentScene(scene, transition: crossFade)
                    (UIApplication.sharedApplication().keyWindow?.rootViewController as! GameViewController).addGestureRecognizers()
                }
            }
        })
    }
}
