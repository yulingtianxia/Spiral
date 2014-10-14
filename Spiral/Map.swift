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
    var spacing:CGFloat = 0.0
    var points:[CGPoint] = []
    convenience init(origin:CGPoint,layer:Int, size:CGSize){
        
        var x:CGFloat = origin.x
        var y:CGFloat = origin.y
        var path = CGPathCreateMutable()
        self.init()
        spacing = size.width / CGFloat(layer * 2-1)
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
        addRope(layer)
    }
    
    func addRope(layer:Int){
        var center:CGPoint
        var distance:CGFloat = 0
        var rope:Rope
        for index in 0..<layer-1 {
            distance = points[index*4].y - points[index*4+1].y
            while distance > 0 {
                rope = Rope(length: distance)
                rope.zRotation = 0
                distance -= rope.size.height
                center = CGPoint(x: points[index*4].x, y: points[index*4+1].y+distance+rope.size.height/2)
                rope.position = center
                self.addChild(rope)
            }
            distance = points[index*4+1].x - points[index*4+2].x
            while distance > 0 {
                rope = Rope(length: distance)
                rope.zRotation = CGFloat(M_PI_2)
                distance -= rope.size.height
                center = CGPoint(x: points[index*4+2].x+distance+rope.size.height/2, y: points[index*4+1].y)
                rope.position = center
                self.addChild(rope)
            }
            distance = points[index*4+3].y - points[index*4+2].y
            while distance > 0 {
                rope = Rope(length: distance)
                rope.zRotation = CGFloat(M_PI)
                distance -= rope.size.height
                center = CGPoint(x: points[index*4+2].x, y: points[index*4+3].y-distance-rope.size.height/2)
                rope.position = center
                self.addChild(rope)
            }
            distance = points[(1+index)*4].x - points[index*4+3].x
            while distance > 0 {
                rope = Rope(length: distance)
                rope.zRotation = CGFloat(3*M_PI_2)
                distance -= rope.size.height
                center = CGPoint(x: points[(1+index)*4].x-distance-rope.size.height/2, y: points[index*4+3].y)
                rope.position = center
                self.addChild(rope)
            }
        }
    }
}
