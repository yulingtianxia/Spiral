//
//  MainScene.swift
//  Spiral
//
//  Created by 杨萧玉 on 15/5/10.
//  Copyright (c) 2015年 杨萧玉. All rights reserved.
//

import SpriteKit

class MainScene: SKScene, SKPhysicsContactDelegate {
    let ordinaryBtn = OrdinaryButton()
    let zenBtn = ZenButton()
    let spiralLabel = SKLabelNode(text: "Spiral")
    override init(size: CGSize) {
        super.init(size: size)
        let center = CGPointMake(size.width/2, size.height/2)
        //添加背景
        let background = Background(size: size, imageName: "bg_main")
        background.position = center
        addChild(background)
        
        //添加牛逼的 Logo
        spiralLabel.fontName = "Chalkboard SE Regular"
        spiralLabel.fontSize = 100
        spiralLabel.position = CGPoint(x: center.x, y: center.y * 1.5)
        spiralLabel
        addChild(spiralLabel)
        
        //添加模式选择按钮
        ordinaryBtn.position = CGPoint(x: center.x, y: CGRectGetMinY(spiralLabel.frame) - ordinaryBtn.size.height/2)
        zenBtn.position = CGPoint(x: center.x, y: CGRectGetMinY(ordinaryBtn.frame) - zenBtn.size.height/2)
        addChild(ordinaryBtn)
        addChild(zenBtn)
        
        //设定物理特性
        physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = mainSceneCategory
        physicsBody?.collisionBitMask = playerCategory|killerCategory|scoreCategory|shieldCategory|reaperCategory
        physicsBody?.contactTestBitMask = 0
        physicsBody?.linearDamping = 0
        physicsBody?.angularDamping = 0
//        physicsBody?.restitution = 1
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        createShapes()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //产生 Shape
    func createShapes() {
        let center = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
        //创建所有 shape
        let player = Player()
        let killer = Killer()
        let score = Score()
        let shield = Shield()
        let reaper = Reaper()
        //设定起始点
        player.position = center
        killer.position = center
        score.position = center
        shield.position = center
        reaper.position = center
        //取消碰撞检测
        player.physicsBody?.contactTestBitMask = 0
        killer.physicsBody?.contactTestBitMask = 0
        score.physicsBody?.contactTestBitMask = 0
        shield.physicsBody?.contactTestBitMask = 0
        reaper.physicsBody?.contactTestBitMask = 0
        //赋予随机初速度
        player.physicsBody?.velocity = randomVelocity()
        killer.physicsBody?.velocity = randomVelocity()
        score.physicsBody?.velocity = randomVelocity()
        shield.physicsBody?.velocity = randomVelocity()
        reaper.physicsBody?.velocity = randomVelocity()
        //点亮照明灯
        player.light.enabled = true
        killer.light.enabled = true
        score.light.enabled = true
        shield.light.enabled = true
        reaper.light.enabled = true
        //添加到场景
        addChild(player)
        addChild(killer)
        addChild(score)
        addChild(shield)
        addChild(reaper)
    }
    
    //产生随机速度
    func randomVelocity() -> CGVector {
        let x = CGFloat(arc4random_uniform(1000)) - 500
        let y = CGFloat(arc4random_uniform(1000)) - 500
        return CGVector(dx: x, dy: y)
    }
}
