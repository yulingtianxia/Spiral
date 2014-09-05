//
//  Display.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-7-15.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import SpriteKit
protocol DisplayData{
    func updateData()
    func levelUp()
    func gameOver()
    func restart()
}
class Display: SKNode ,DisplayData{
    let scoreLabel = SKLabelNode(text: "SCORE \(Data.score)")
    let levelLabel = SKLabelNode(text: "LEVEL \(Data.level)")
    let highScoreLabel = SKLabelNode(text: "HIGHSCORE \(Data.highScore)")
    let gameOverLabel = SKLabelNode(text: "GAME OVER")
    let share = ShareButton()
    let replay = ReplayButton()
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    override init(){
        super.init()
        gameOverLabel.fontSize = 60
        self.addChild(scoreLabel)
        self.addChild(levelLabel)
    }
    
    func setPosition() {
        scoreLabel.position = CGPointMake(CGRectGetMidX(self.scene!.frame), CGRectGetMaxY(self.scene!.frame)/8)
        highScoreLabel.position = CGPointMake(CGRectGetMidX(self.scene!.frame), CGRectGetMinY(self.scene!.frame))
        levelLabel.position = CGPointMake(CGRectGetMidX(self.scene!.frame), 4*CGRectGetMaxY(self.scene!.frame)/5)
        gameOverLabel.position = CGPointMake(CGRectGetMidX(self.scene!.frame), CGRectGetMidY(self.scene!.frame))
        share.position = CGPointMake(CGRectGetMaxX(self.scene!.frame)*3/4, CGRectGetMaxY(self.scene!.frame)/4)
        replay.position = CGPointMake(CGRectGetMaxX(self.scene!.frame)/4, CGRectGetMaxY(self.scene!.frame)/4)
    }
    func updateData() {
        scoreLabel.text = "SCORE \(Data.score)"
        levelLabel.text = "LEVEL \(Data.level)"
    }
    func levelUp() {
        levelLabel.runAction(SKAction.sequence([SKAction.scaleTo(1.5, duration: 0.5),SKAction.scaleTo(1, duration: 0.5)]))
        (self.scene as GameScene).speedUp()
    }
    func gameOver() {
        self.addChild(gameOverLabel)
        self.addChild(share)
        self.addChild(replay)
        highScoreLabel.text = "HIGHSCORE \(Data.highScore)"
        self.addChild(highScoreLabel)
        (self.scene as GameScene).overGame()
    }
    func restart() {
        gameOverLabel.removeFromParent()
        share.removeFromParent()
        replay.removeFromParent()
        highScoreLabel.removeFromParent()
        (self.scene as GameScene).restartGame()
    }
}
