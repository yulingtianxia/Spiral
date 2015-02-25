//
//  HelpButton.swift
//  Spiral
//
//  Created by 杨萧玉 on 14/10/19.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import SpriteKit

class HelpButton: SKSpriteNode {
    override init(){
        super.init(texture: SKTexture(imageNamed: "help"), color: SKColor.clearColor(), size: CGSize(width: 30, height: 30))
        self.userInteractionEnabled = true
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let scene = HelpScene.unarchiveFromFile("HelpScene") as? HelpScene{
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            self.scene?.view?.presentScene(scene, transition: reveal)
            (UIApplication.sharedApplication().keyWindow?.rootViewController as! GameViewController).addGestureRecognizers()
        }
    }
}
