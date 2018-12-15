//
//  Display.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-7-15.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import SpriteKit

class OrdinaryDisplay: SKNode ,DisplayData{
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
        scoreLabel.position = CGPoint(x: scene!.frame.midX, y: scene!.frame.maxY/8)
        highScoreLabel.position = CGPoint(x: scene!.frame.midX, y: scene!.frame.minY+5)
        levelLabel.position = CGPoint(x: scene!.frame.midX, y: 4*scene!.frame.maxY/5)
        gameOverLabel.position = CGPoint(x: scene!.frame.midX, y: scene!.frame.midY)
        share.position = CGPoint(x: scene!.frame.maxX*3/4, y: scene!.frame.maxY/4)
        replay.position = CGPoint(x: scene!.frame.maxX/4, y: scene!.frame.maxY/4)
        playRecord.position = CGPoint(x: scene!.frame.midX, y: scene!.frame.maxY/4)
        gameCenter.position = CGPoint(x: gameCenter.size.width/2, y: scene!.size.height-gameCenter.size.height/2)
        pauseLabel.position = CGPoint(x: scene!.frame.midX, y: scene!.frame.midY)
        reaperIcon.position = CGPoint(x: reaperIcon.size.width/2, y: reaperIcon.frame.height/2)
        reaperNumLabel.position = CGPoint(x: reaperIcon.frame.maxX + 5 + reaperNumLabel.frame.width/2, y: reaperNumLabel.frame.height/4)
        help.position = CGPoint(x: scene!.size.width-help.size.width/2, y: scene!.size.height-help.size.height/2)
        tipsLabel.position = CGPoint(x: gameOverLabel.position.x, y: (gameOverLabel.position.y + share.position.y)/2)
        
    }
    
    func disableButtons() {
        share.isUserInteractionEnabled = false
        replay.isUserInteractionEnabled = false
        playRecord.isUserInteractionEnabled = false
        gameCenter.isUserInteractionEnabled = false
        help.isUserInteractionEnabled = false
        gameOverLabel.isUserInteractionEnabled = false
    }
    
    // MARK: - DisplayData
    
    func updateData() {
        scoreLabel.text = NSLocalizedString("SCORE ", comment: "")+"\(Data.sharedData.score)"
        levelLabel.text = NSLocalizedString("LEVEL ", comment: "")+"\(Data.sharedData.level)"
        reaperNumLabel.text = String.localizedStringWithFormat("%d", Data.sharedData.reaperNum)
    }
    
    func levelUp() {
        levelLabel.run(SKAction.sequence([SKAction.scale(to: 1.5, duration: 0.5),SKAction.scale(to: 1, duration: 0.5)]))
        let scene = self.scene as! OrdinaryModeScene
        scene.speedUp()
        scene.soundManager.playLevelUp()
    }
    
    func gameOver() {
        let scene = self.scene as! OrdinaryModeScene
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
        DispatchQueue.main.async {
            if let gvc = UIApplication.shared.keyWindow?.rootViewController as? GameViewController {
                gvc.stopRecord()
                gvc.removeGestureRecognizers()
            }
        }
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
        (scene as! OrdinaryModeScene).restartGame()
        (UIApplication.shared.keyWindow?.rootViewController as! GameViewController).addGestureRecognizers()
    }
    
    //MARK: - pause&resume
    
    func pause(){
        pauseLabel.text = NSLocalizedString("PAUSE", comment: "")
        pauseLabel.alpha = 1
        (scene as! OrdinaryModeScene).hideGame()
    }
    
    func resume(){
        pauseLabel.text = ""
        pauseLabel.alpha = 0
        if !Data.sharedData.gameOver{
            (scene as! OrdinaryModeScene).showGame()
        }
    }
}
