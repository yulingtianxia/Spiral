//
//  ZenMap.swift
//  Spiral
//
//  Created by 杨萧玉 on 15/5/1.
//  Copyright (c) 2015年 杨萧玉. All rights reserved.
//

import UIKit
import SpriteKit
public class ZenMap: SKNode {
    var rightPath:[CGPoint] = []
    var downPath:[CGPoint] = []
    var leftPath:[CGPoint] = []
    var upPath:[CGPoint] = []
    var spacing:CGFloat = 0.0
    var points:[PathOrientation:[CGPoint]]!
    public convenience init(origin:CGPoint, layer:Int, size:CGSize) {
        self.init()
        //计算每层路径间隔距离
        spacing = size.width / CGFloat((layer + 2) * 2)
        var needles = [CGPoint(x: origin.x + spacing, y: origin.y),CGPoint(x: origin.x, y: origin.y - spacing),CGPoint(x: origin.x - spacing, y: origin.y),CGPoint(x: origin.x, y: origin.y + spacing)]
        //init paths
        rightPath.append(origin)
        downPath.append(origin)
        leftPath.append(origin)
        upPath.append(origin)
        rightPath.append(needles[0])
        downPath.append(needles[1])
        leftPath.append(needles[2])
        upPath.append(needles[3])
        
        for index in 1...layer {
            let increment = spacing * 2 * CGFloat(index)
            //turn right
            needles[3 - ((index + 3) % 4)].x += increment
            //turn down
            needles[3 - ((index + 2) % 4)].y -= increment
            //turn left
            needles[3 - ((index + 1) % 4)].x -= increment
            //turn up
            needles[3 - ((index + 0) % 4)].y += increment
            //append to paths
            rightPath.append(needles[0])
            downPath.append(needles[1])
            leftPath.append(needles[2])
            upPath.append(needles[3])
        }
        points = [.right:rightPath,.down:downPath,.left:leftPath,.up:upPath]
        addBamboos()
    }
    
    //将地图节点数组用绳子串起来
    func addBamboos(){
        for index in 0..<rightPath.count-1 {
            addBamboosFromPointA(rightPath[index], toPointB: rightPath[index + 1])
        }
        for index in 0..<downPath.count-1 {
            addBamboosFromPointA(downPath[index], toPointB: downPath[index + 1])
        }
        for index in 0..<leftPath.count-1 {
            addBamboosFromPointA(leftPath[index], toPointB: leftPath[index + 1])
        }
        for index in 0..<upPath.count-1 {
            addBamboosFromPointA(upPath[index], toPointB: upPath[index + 1])
        }
    }
    
    //递归填充比图片长的直线
    func addBamboosFromPointA(a:CGPoint, toPointB b:CGPoint){
        let xDistance = b.x-a.x
        let yDistance = b.y-a.y
        let distance = sqrt(xDistance * xDistance + yDistance * yDistance)
        let bamboo = Bamboo(length: distance)
        bamboo.zRotation = atan(xDistance / yDistance)
        let scale = bamboo.size.height / distance
        let realB = CGPoint(x: a.x + scale * xDistance, y: a.y + scale * yDistance)
        if scale < 1 {
            addBamboosFromPointA(realB, toPointB: b)
        }
        let center = CGPoint(x: (a.x + realB.x)/2, y: (a.y + realB.y)/2)
        bamboo.position = center
        addChild(bamboo)
    }
}
