//
//  HelpButton.swift
//  Spiral
//
//  Created by 杨萧玉 on 14/10/19.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import SpriteKit

class HelpButton: SKSpriteNode {
    
    init(){
        super.init(texture: SKTexture(imageNamed: "help"), color: SKColor.clearColor(), size: CGSize(width: 30, height: 30))
        self.userInteractionEnabled = true
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        let loading = SKSpriteNode(imageNamed: "loading")
        loading.position = CGPoint(x: CGRectGetMidX(self.scene!.frame), y: CGRectGetMidY(self.scene!.frame));
        self.scene?.addChild(loading)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
            if let scene = HelpScene.unarchiveFromFile("HelpScene") as? HelpScene {
                loading.removeFromParent()
                let crossFade = SKTransition.crossFadeWithDuration(2)
                crossFade.pausesIncomingScene = false
                self.scene?.view?.presentScene(scene, transition: crossFade)
                (UIApplication.sharedApplication().keyWindow?.rootViewController as! GameViewController).addGestureRecognizers()
            }
        })
    }
}
