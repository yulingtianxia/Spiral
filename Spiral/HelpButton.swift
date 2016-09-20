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
        case .ordinary:
            imageString = "help_ordinary"
        case .zen:
            imageString = "help_zen"
        case .maze:
            imageString = "help_maze"
        }
        super.init(texture: SKTexture(imageNamed: imageString), color: SKColor.clear, size: CGSize(width: 40, height: 40))
        isUserInteractionEnabled = true
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let loading = SKSpriteNode(imageNamed: "loading")
        loading.position = CGPoint(x: self.scene!.frame.midX, y: self.scene!.frame.midY)
        loading.zPosition = 150
        self.scene?.addChild(loading)
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async(execute: { () -> Void in
            Data.sharedData.display = nil
            (self.parent as? DisplayData)?.disableButtons()
            switch Data.sharedData.currentMode {
            case .ordinary:
                if let scene = OrdinaryHelpScene.unarchiveFromFile("OrdinaryHelpScene") as? OrdinaryHelpScene {
                    loading.removeFromParent()
                    let crossFade = SKTransition.crossFade(withDuration: 2)
                    crossFade.pausesIncomingScene = false
                    self.scene?.view?.presentScene(scene, transition: crossFade)
                    (UIApplication.shared.keyWindow?.rootViewController as! GameViewController).addGestureRecognizers()
                }
            case .zen:
                if let scene = ZenHelpScene.unarchiveFromFile("ZenHelpScene") as? ZenHelpScene {
                    loading.removeFromParent()
                    let crossFade = SKTransition.crossFade(withDuration: 2)
                    crossFade.pausesIncomingScene = false
                    self.scene?.view?.presentScene(scene, transition: crossFade)
                    (UIApplication.shared.keyWindow?.rootViewController as! GameViewController).addGestureRecognizers()
                }
            case .maze:
                if let scene = MazeHelpScene.unarchiveFromFile("MazeHelpScene") as? MazeHelpScene {
                    loading.removeFromParent()
                    let crossFade = SKTransition.crossFade(withDuration: 2)
                    crossFade.pausesIncomingScene = false
                    self.scene?.view?.presentScene(scene, transition: crossFade)
                    (UIApplication.shared.keyWindow?.rootViewController as! GameViewController).addGestureRecognizers()
                }
            }
        })
    }
}
