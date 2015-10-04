//
//  Constant.swift
//  Spiral
//
//  Created by 杨萧玉 on 15/6/5.
//  Copyright (c) 2015年 杨萧玉. All rights reserved.
//

import UIKit

//SKSpriteNode
let mainSceneCategory:UInt32   =  0x1 << 0
let killerCategory:UInt32      =  0x1 << 1
let scoreCategory:UInt32       =  0x1 << 2
let shieldCategory:UInt32      =  0x1 << 3
let reaperCategory:UInt32      =  0x1 << 4
let eyeCategory:UInt32         =  0x1 << 5
let playerCategory:UInt32      =  0x1 << 6
//SKLightNode
let killerLightCategory:UInt32 =  0x1 << 0
let playerLightCategory:UInt32 =  0x1 << 1
let scoreLightCategory:UInt32  =  0x1 << 2
let shieldLightCategory:UInt32 =  0x1 << 3
let reaperLightCategory:UInt32 =  0x1 << 4
let bgLightCategory:UInt32     =  0x1 << 5

enum ShapeType {
    case Player
    case Shield
    case Killer
    case Score
    case Reaper
}

let mainButtonSize = CGSize(width: 150, height: 150)
let mazeCellWidth: CGFloat = UIScreen.mainScreen().bounds.width / 30
