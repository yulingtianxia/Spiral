//
//  Map.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-7-12.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import UIKit
import SpriteKit
class Map: SKShapeNode {
    convenience init(origin:CGPoint,layer:CGFloat){
        let spacing:CGFloat = 30
        var x:CGFloat = origin.x
        var y:CGFloat = origin.y
        var path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, x, y)
        for index in 1..<layer{
            y-=spacing*(2*index-1)
            CGPathAddLineToPoint(path, nil , x, y)
            x-=spacing*(2*index-1)
            CGPathAddLineToPoint(path, nil , x, y)
            y+=spacing*2*index
            CGPathAddLineToPoint(path, nil , x, y)
            x+=spacing*2*index
            CGPathAddLineToPoint(path, nil , x, y)
        }
        self.init()
        self.path = path
        self.glowWidth = 1
        self.antialiased = true
    }
}
