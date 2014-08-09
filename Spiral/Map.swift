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
    let spacing:CGFloat = 35
    var points:[CGPoint] = []
    convenience init(origin:CGPoint,layer:Int){
        
        var x:CGFloat = origin.x
        var y:CGFloat = origin.y
        var path = CGPathCreateMutable()
        self.init()
        CGPathMoveToPoint(path, nil, x, y)
        points.append(CGPointMake(x, y))
        for index in 1..<layer {
            y-=spacing*(2*CGFloat(index)-1)
            CGPathAddLineToPoint(path, nil , x, y)
            points.append(CGPointMake(x, y))
            x-=spacing*(2*CGFloat(index)-1)
            CGPathAddLineToPoint(path, nil , x, y)
            points.append(CGPointMake(x, y))
            y+=spacing*2*CGFloat(index)
            CGPathAddLineToPoint(path, nil , x, y)
            points.append(CGPointMake(x, y))
            x+=spacing*2*CGFloat(index)
            CGPathAddLineToPoint(path, nil , x, y)
            points.append(CGPointMake(x, y))
        }
        self.path = path
        self.glowWidth = 1

        self.antialiased = true
    }
}
