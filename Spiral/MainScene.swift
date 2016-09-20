//
//  MainScene.swift
//  Spiral
//
//  Created by 杨萧玉 on 15/5/10.
//  Copyright (c) 2015年 杨萧玉. All rights reserved.
//

import SpriteKit
import CoreMotion

private let kShapeSize = CGSize(width: 50, height: 50)
private let kUpdateInterval:TimeInterval = Double(1)/60
private let kAccelerateScale:Double = 100
private let kRandomSpeed:UInt32 = 100

class MainScene: SKScene, SKPhysicsContactDelegate {
//    模式选择按钮
    let ordinaryBtn = OrdinaryButton()
    let zenBtn = ZenButton()
    let mazeBtn = MazeButton()
//    logo
    let spiralLabel = SKLabelNode(text: "Spiral")
//    GameCenter 按钮
    let gameCenter = GameCenterButton()
//    游戏录制按钮
    let autoRecord = AutoRecordButton()
//    加速计管理器
    let mManager = MotionManager.sharedMotionManager
//    主页面漂浮的各类 Shape 数组
    var shapes = [Shape]()
    
    override init(size: CGSize) {
        super.init(size: size)
        let center = CGPoint(x: size.width/2, y: size.height/2)
        //添加背景
        let background = Background(size: size, imageName: "bg_main")
        background.position = center
        addChild(background)
        
        Data.sharedData.gameOver = true
        
        //添加牛逼的 Logo
        spiralLabel.fontName = "Chalkboard SE Regular"
        spiralLabel.fontSize = 100
        spiralLabel.position = CGPoint(x: center.x, y: center.y * 1.5)

        addChild(spiralLabel)
        
        //添加 GameCenter 按钮
        gameCenter.position = CGPoint(x: gameCenter.size.width/2, y: scene!.size.height-gameCenter.size.height/2)
        gameCenter.zPosition = 101
        addChild(gameCenter)
        
        //添加 AutoRecord 按钮
        autoRecord.position = CGPoint(x: frame.maxX - autoRecord.size.width / 2, y: frame.maxY - autoRecord.size.height / 2)
        autoRecord.zPosition = 101
        addChild(autoRecord)
        
        //添加模式选择按钮
        ordinaryBtn.position = CGPoint(x: center.x - ordinaryBtn.size.width/2, y: spiralLabel.frame.minY - ordinaryBtn.size.height/2)
        zenBtn.position = CGPoint(x: center.x + zenBtn.size.width/2, y: spiralLabel.frame.minY - ordinaryBtn.size.height/2)
        mazeBtn.position = CGPoint(x: center.x - mazeBtn.size.width/2, y: ordinaryBtn.frame.minY - zenBtn.size.height/2)
        addChild(ordinaryBtn)
        addChild(zenBtn)
        addChild(mazeBtn)
        
        //设定物理特性
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = mainSceneCategory
        physicsBody?.collisionBitMask = playerCategory|killerCategory|scoreCategory|shieldCategory|reaperCategory
        physicsBody?.contactTestBitMask = 0
        physicsBody?.linearDamping = 0
        physicsBody?.angularDamping = 0
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        //创建 shape
        createShapes()
        
        //监听加速计数据
        if mManager.isDeviceMotionAvailable {
            mManager.deviceMotionUpdateInterval = kUpdateInterval
            mManager.startDeviceMotionUpdates()
            mManager.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: { (deviceMotion, error) -> Void in
                if error != nil {
                    print(error!.localizedDescription, terminator: "")
                }
                else if let acceleration = deviceMotion?.userAcceleration{
                    for shape in self.shapes {
                        let mass = shape.physicsBody!.mass
                        let impulse = CGVector(dx: -mass * acceleration.x * kAccelerateScale, dy: -mass * acceleration.y * kAccelerateScale)
                        shape.physicsBody?.applyImpulse(impulse)
                    }
                }
            })
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //产生 Shape
    func createShapes() {
        let center = CGPoint(x: frame.midX, y: frame.midY)
        //创建所有 shape
        let player = Player()
        let killer = Killer()
        let score = Score()
        let shield = Shield()
        let reaper = Reaper()
        
        //设定起始点
        player.position = center
        killer.position = CGPoint(x: kShapeSize.width, y: kShapeSize.height)
        score.position = CGPoint(x: kShapeSize.width, y: frame.size.height - kShapeSize.height)
        shield.position = CGPoint(x: frame.size.width - kShapeSize.width, y: kShapeSize.height)
        reaper.position = CGPoint(x: frame.size.width - kShapeSize.width, y: frame.size.height - kShapeSize.height)
        
        shapes = [player,killer,score,shield,reaper]
        
        for shape in shapes {
            
            shape.size = kShapeSize
            //使用像素级物理体
            shape.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
            //设置碰撞
            shape.physicsBody?.contactTestBitMask = 0
            shape.physicsBody?.usesPreciseCollisionDetection = true
            shape.physicsBody?.collisionBitMask = mainSceneCategory
            shape.physicsBody?.usesPreciseCollisionDetection = true
            shape.zPosition = 100
            //设置速度衰减和表面摩擦
            shape.physicsBody?.angularDamping = 0
            shape.physicsBody?.linearDamping = 0
            shape.physicsBody?.restitution = 0.5
            shape.physicsBody?.friction = 1.0
            shape.normalTexture = shape.texture?.generatingNormalMap()
            //赋予随机初速度
            shape.physicsBody?.velocity = randomVelocity()
            //点亮照明灯
            shape.light.isEnabled = false
            //添加到场景
            addChild(shape)
        }
    }
    
    //产生随机速度
    func randomVelocity() -> CGVector {
        let x = CGFloat(arc4random_uniform(kRandomSpeed)) - CGFloat(kRandomSpeed/2)
        let y = CGFloat(arc4random_uniform(kRandomSpeed)) - CGFloat(kRandomSpeed/2)
        return CGVector(dx: x, dy: y)
    }
    
    override func didSimulatePhysics() {
//        if let deviceMotion = mManager.deviceMotion {
//            let acceleration = deviceMotion.userAcceleration
//            for shape in self.shapes {
//                let mass = shape.physicsBody!.mass
//                let impulse = CGVector(dx: -mass * acceleration.x * kAccelerateScale, dy: -mass * acceleration.y * kAccelerateScale)
//                shape.physicsBody?.applyImpulse(impulse)
//            }
//        }
    }
    
    deinit {
        mManager.stopDeviceMotionUpdates()
    }
    
}
