//
//  HelpFile.swift
//  Spiral
//
//  Created by 杨萧玉 on 15/6/9.
//  Copyright (c) 2015年 杨萧玉. All rights reserved.
//

import SpriteKit

func * (left:CGFloat, right:Double) -> Double {
    return Double(left) * right
}

func * (left:Int, right:CGFloat) -> CGFloat {
    return CGFloat(left) * right
}

func * (left:Int32, right:CGFloat) -> CGFloat {
    return CGFloat(left) * right
}

func * (left:CGSize, right:CGFloat) -> CGSize {
    return CGSize(width: left.width * right, height: left.height * right)
}

func == (left: vector_int2, right: vector_int2) -> Bool {
    return left.x == right.x && left.y == right.y
}

func != (left: vector_int2, right: vector_int2) -> Bool {
    return !(left == right)
}

func + (left: vector_int2, right: vector_int2) -> vector_int2 {
    return vector_int2(left.x + right.x, left.y + right.y)
}

func - (left: vector_int2, right: vector_int2) -> vector_int2 {
    return vector_int2(left.x - right.x, left.y - right.y)
}

func / (left: Int, right: CGFloat) -> CGFloat {
    return CGFloat(left) / right
}

func ==(lhs: Line, rhs: Line) -> Bool {
    return lhs.pa == rhs.pa && lhs.pb == rhs.pb
}

