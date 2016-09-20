//
//  MotionManager.swift
//  Spiral
//
//  Created by 杨萧玉 on 15/6/9.
//  Copyright (c) 2015年 杨萧玉. All rights reserved.
//

import CoreMotion

class MotionManager {
    
    fileprivate static let instance = CMMotionManager()
    
    class var sharedMotionManager : CMMotionManager {
        return instance
    }
}
