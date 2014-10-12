//
//  GameCenterButton.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-10-12.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import SpriteKit

class GameCenterButton: SKSpriteNode {
    override init(){
        super.init(texture: SKTexture(imageNamed: "GameCenter"), color: SKColor.clearColor(), size: CGSize(width: 25, height: 25))
        self.userInteractionEnabled = true
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        GameKitHelper.sharedGameKitHelper().showLeaderboard()
    }
    
}
