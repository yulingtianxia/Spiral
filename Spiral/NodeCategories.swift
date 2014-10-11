//
//  NodeCategories.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-7-13.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import Foundation

//SKSpriteNode
let playerCategory:UInt32      =  0x1 << 0;
let killerCategory:UInt32      =  0x1 << 1;
let scoreCategory:UInt32       =  0x1 << 2;
let shieldCategory:UInt32      =  0x1 << 3;
let reaperCategory:UInt32      =  0x1 << 4;

//SKLightNode
let killerLightCategory:UInt32 =  0x1 << 0;
let playerLightCategory:UInt32 =  0x1 << 1;
let scoreLightCategory:UInt32  =  0x1 << 2;
let shieldLightCategory:UInt32 =  0x1 << 3;
let reaperLightCategory:UInt32 =  0x1 << 4;
let bgLightCategory:UInt32     =  0x1 << 5;