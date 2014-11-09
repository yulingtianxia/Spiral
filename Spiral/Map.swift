//
//  Map.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-7-12.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import UIKit
import SpriteKit
public class Map: SKShapeNode {
    var spacing:CGFloat = 0.0
    var points:[CGPoint] = []
    public convenience init(origin:CGPoint,layer:Int, size:CGSize){
        
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
        addRopes()
    }
    //将地图节点数组用绳子串起来
    func addRopes(){
        var center:CGPoint
        var distance:CGFloat = 0
        var rope:Rope
        for index in 0..<points.count-1 {
            addRopesToLine(points[index], b: points[index + 1])
        }
    }
    //递归填充比图片长的直线
    func addRopesToLine(a:CGPoint,b:CGPoint){
        let xDistance = b.x-a.x
        let yDistance = b.y-a.y
        var distance = sqrt(xDistance * xDistance + yDistance * yDistance)
        let rope = Rope(length: distance)
        rope.zRotation = atan(xDistance / yDistance)
        let scale = rope.size.height / distance
        let realB = CGPoint(x: a.x + scale * xDistance, y: a.y + scale * yDistance)
        if scale < 1 {
            addRopesToLine(realB, b: b)
        }
        let center = CGPoint(x: (a.x + realB.x)/2, y: (a.y + realB.y)/2)
        rope.position = center
        addChild(rope)
    }
    
}
