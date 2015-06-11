//
//  HelpFile.swift
//  Spiral
//
//  Created by 杨萧玉 on 15/6/9.
//  Copyright (c) 2015年 杨萧玉. All rights reserved.
//

import Foundation

func * (left:CGFloat, right:Double) -> Double {
    return Double(left) * right
}

func * (left:Int, right:CGFloat) -> CGFloat {
    return CGFloat(left) * right
}