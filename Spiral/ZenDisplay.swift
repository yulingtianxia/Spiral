//
//  ZenDisplay.swift
//  Spiral
//
//  Created by 杨萧玉 on 15/5/3.
//  Copyright (c) 2015年 杨萧玉. All rights reserved.
//

import SpriteKit

class ZenDisplay: SKNode, DisplayData {
    let scoreLabel = SKLabelNode(text: NSLocalizedString("SCORE ", comment: "")+"\(Data.sharedData.score)")
    let levelLabel = SKLabelNode(text:NSLocalizedString("LEVEL ", comment: "")+"\(Data.sharedData.level)")
    let highScoreLabel = SKLabelNode(text: NSLocalizedString("HIGHSCORE ", comment: "")+"\(Data.sharedData.highScore)")
    let gameOverLabel = GameOverIcon(size: CGSize(width: 200, height: 120))
    let pauseLabel = SKLabelNode(text: NSLocalizedString("PAUSE", comment: ""))
    let reaperIcon = SKSpriteNode(imageNamed: "reaper")
    let reaperNumLabel = SKLabelNode(text: String.localizedStringWithFormat("%d", Data.sharedData.reaperNum))
    let tipsLabel = SKLabelNode(text: NSLocalizedString("TIPS", comment: ""))
    let share = ShareButton()
    let replay = ReplayButton()
    let playRecord = PlayRecordButton()
    let gameCenter = GameCenterButton()
    let help = HelpButton()
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(){
        super.init()
        zPosition = 120
        pauseLabel.fontSize = 60
        pauseLabel.alpha = 0
        reaperIcon.size = CGSize(width: 20, height: 20)
        reaperNumLabel.fontSize = 20
        tipsLabel.fontSize = 12
        scoreLabel.setDefaultFont()
        highScoreLabel.setDefaultFont()
        levelLabel.setDefaultFont()
        pauseLabel.setDefaultFont()
        reaperNumLabel.setDefaultFont()
        tipsLabel.setDefaultFont()
        addChild(scoreLabel)
        addChild(levelLabel)
        addChild(pauseLabel)
        addChild(reaperIcon)
        addChild(reaperNumLabel)
    }
    
    func setPosition() {
        scoreLabel.position = CGPointMake(CGRectGetMidX(scene!.frame), CGRectGetMaxY(scene!.frame)/8)
        highScoreLabel.position = CGPointMake(CGRectGetMidX(scene!.frame), CGRectGetMinY(scene!.frame)+5)
        levelLabel.position = CGPointMake(CGRectGetMidX(scene!.frame), 4*CGRectGetMaxY(scene!.frame)/5)
        gameOverLabel.position = CGPointMake(CGRectGetMidX(scene!.frame), CGRectGetMidY(scene!.frame))
        share.position = CGPointMake(CGRectGetMaxX(scene!.frame)*3/4, CGRectGetMaxY(scene!.frame)/4)
        replay.position = CGPointMake(CGRectGetMaxX(scene!.frame)/4, CGRectGetMaxY(scene!.frame)/4)
        playRecord.position = CGPoint(x: CGRectGetMidX(scene!.frame), y: CGRectGetMaxY(scene!.frame)/4)
        gameCenter.position = CGPoint(x: gameCenter.size.width/2, y: scene!.size.height-gameCenter.size.height/2)
        pauseLabel.position = CGPointMake(CGRectGetMidX(scene!.frame), CGRectGetMidY(scene!.frame))
        reaperIcon.position = CGPoint(x: reaperIcon.size.width/2, y: reaperIcon.frame.height/2)
        reaperNumLabel.position = CGPoint(x: CGRectGetMaxX(reaperIcon.frame) + 5 + reaperNumLabel.frame.width/2, y: reaperNumLabel.frame.height/4)
        help.position = CGPoint(x: scene!.size.width-help.size.width/2, y: scene!.size.height-help.size.height/2)
        tipsLabel.position = CGPoint(x: gameOverLabel.position.x, y: (gameOverLabel.position.y + share.position.y)/2)
        
    }
    
    func disableButtons() {
        share.userInteractionEnabled = false
        replay.userInteractionEnabled = false
        playRecord.userInteractionEnabled = false
        gameCenter.userInteractionEnabled = false
        help.userInteractionEnabled = false
        gameOverLabel.userInteractionEnabled = false
    }
    
    // MARK: - DisplayData
    
    func updateData() {
        scoreLabel.text = NSLocalizedString("SCORE ", comment: "")+"\(Data.sharedData.score)"
        levelLabel.text = NSLocalizedString("LEVEL ", comment: "")+"\(Data.sharedData.level)"
        reaperNumLabel.text = String.localizedStringWithFormat("%d", Data.sharedData.reaperNum)
    }
    
    func levelUp() {
        levelLabel.runAction(SKAction.sequence([SKAction.scaleTo(1.5, duration: 0.5),SKAction.scaleTo(1, duration: 0.5)]))
        let scene = self.scene as! ZenModeScene
        scene.speedUp()
        scene.soundManager.playLevelUp()
    }
    
    func gameOver() {
        let scene = self.scene as! ZenModeScene
        for child in scene.children{
            child.removeAllActions()
        }
        addChild(gameOverLabel)
        addChild(share)
        addChild(replay)
        addChild(playRecord)
        addChild(gameCenter)
        addChild(help)
        let tipNum = Int(arc4random_uniform(9))
        tipsLabel.text = NSLocalizedString(tips[tipNum], comment: "tips")
        addChild(tipsLabel)
        reaperIcon.removeFromParent()
        reaperNumLabel.removeFromParent()
        highScoreLabel.text = NSLocalizedString("HIGHSCORE ", comment: "")+"\(Data.sharedData.highScore)"
        addChild(highScoreLabel)
        scene.hideGame()
        scene.soundManager.playGameOver()
        let gvc = UIApplication.sharedApplication().keyWindow?.rootViewController as! GameViewController
        gvc.stopRecord()
        gvc.removeGestureRecognizers()
    }
    
    func restart() {
        gameOverLabel.removeFromParent()
        share.removeFromParent()
        replay.removeFromParent()
        playRecord.removeFromParent()
        gameCenter.removeFromParent()
        help.removeFromParent()
        highScoreLabel.removeFromParent()
        tipsLabel.removeFromParent()
        addChild(reaperNumLabel)
        addChild(reaperIcon)
        (scene as! ZenModeScene).restartGame()
        (UIApplication.sharedApplication().keyWindow?.rootViewController as! GameViewController).addGestureRecognizers()
    }
    
    //MARK: - pause&resume
    
    func pause(){
        pauseLabel.text = NSLocalizedString("PAUSE", comment: "")
        pauseLabel.alpha = 1
        (scene as! ZenModeScene).hideGame()
    }
    
    func resume(){
        pauseLabel.text = ""
        pauseLabel.alpha = 0
        if !Data.sharedData.gameOver{
            (scene as! ZenModeScene).showGame()
        }
    }
}
