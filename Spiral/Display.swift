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
    let gameOverLabel = SKLabelNode()
    let share = ShareButton()
    let replay = ReplayButton()
    init(){
        super.init()
        gameOverLabel.fontSize = 60
        self.addChild(scoreLabel)
        self.addChild(levelLabel)
        self.addChild(gameOverLabel)
    }
    func setPosition() {
        scoreLabel.position = CGPointMake(CGRectGetMidX(self.scene.frame), CGRectGetMaxY(self.scene.frame)/8)
        levelLabel.position = CGPointMake(CGRectGetMidX(self.scene.frame), 4*CGRectGetMaxY(self.scene.frame)/5)
        gameOverLabel.position = CGPointMake(CGRectGetMidX(self.scene.frame), CGRectGetMidY(self.scene.frame))
        share.position = CGPointMake(CGRectGetMaxX(self.scene.frame)*3/4, CGRectGetMaxY(self.scene.frame)/4)
        replay.position = CGPointMake(CGRectGetMaxX(self.scene.frame)/4, CGRectGetMaxY(self.scene.frame)/4)
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
        gameOverLabel.text = "GAME OVER"
        self.addChild(share)
        self.addChild(replay)
        (self.scene as GameScene).overGame()
    }
    func restart() {
        gameOverLabel.text = ""
        share.removeFromParent()
        replay.removeFromParent()
        (self.scene as GameScene).restartGame()
    }
}
