//
//  Map.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-7-12.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import UIKit
import SpriteKit
public class OrdinaryMap: SKNode {
    var spacing:CGFloat = 0.0
    var points:[CGPoint] = []
    public convenience init(origin:CGPoint,layer:Int, size:CGSize){
        var x:CGFloat = origin.x
        var y:CGFloat = origin.y
        self.init()
        //计算每层路径间隔距离
        spacing = size.width / CGFloat(layer * 2-1)
        points.append(CGPointMake(x, y))
        for index in 1..<layer {
            y-=spacing*(2*CGFloat(index)-1)
            points.append(CGPointMake(x, y))
            x-=spacing*(2*CGFloat(index)-1)
            points.append(CGPointMake(x, y))
            y+=spacing*2*CGFloat(index)
            points.append(CGPointMake(x, y))
            x+=spacing*2*CGFloat(index)
            points.append(CGPointMake(x, y))
        }
        addRopes()
    }
    //将地图节点数组用绳子串起来
    func addRopes(){
        for index in 0..<points.count-1 {
            addRopesFromPointA(points[index], toPointB: points[index + 1])
        }
    }
    //递归填充比图片长的直线
    func addRopesFromPointA(a:CGPoint, toPointB b:CGPoint){
        let xDistance = b.x-a.x
        let yDistance = b.y-a.y
        var distance = sqrt(xDistance * xDistance + yDistance * yDistance)
        let rope = Rope(length: distance)
        rope.zRotation = atan(xDistance / yDistance)
        let scale = rope.size.height / distance
        let realB = CGPoint(x: a.x + scale * xDistance, y: a.y + scale * yDistance)
        if scale < 1 {
            addRopesFromPointA(realB, toPointB: b)
        }
        let center = CGPoint(x: (a.x + realB.x)/2, y: (a.y + realB.y)/2)
        rope.position = center
        addChild(rope)
    }
    
}
