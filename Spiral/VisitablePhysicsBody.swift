//
//  VisitablePhysicsBody.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-7-14.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import Foundation
import SpriteKit

class VisitablePhysicsBody{
    let body:SKPhysicsBody
    init(body:SKPhysicsBody){
        self.body = body
    }
    func acceptVisitor(visitor:ContactVisitor){
        visitor.visitBody(self.body)
    }
}