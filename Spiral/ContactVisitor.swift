//
//  ContactVistor.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-7-14.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import Foundation
import SpriteKit

class ContactVisitor:NSObject{
    let body:SKPhysicsBody!
    let contact:SKPhysicsContact!
    class func contactVisitorWithBody(body:SKPhysicsBody,forContact contact:SKPhysicsContact)->ContactVisitor!{
        //第一次dispatch，通过node类别返回对应的实例
        if 0 != body.categoryBitMask&playerCategory {
            return PlayerContactVisitor(body: body, forContact: contact)
        }
        if 0 != body.categoryBitMask&killerCategory {
            return KillerContactVisitor(body: body, forContact: contact)
        }
        if 0 != body.categoryBitMask&scoreCategory {
            return ScoreContactVisitor(body: body, forContact: contact)
        }
        return nil
        
    }
    init(body:SKPhysicsBody, forContact contact:SKPhysicsContact){
        self.body = body
        self.contact = contact
        super.init()
        
    }
    func visitBody(body:SKPhysicsBody){
        //第二次dispatch，通过构造方法名来执行对应方法
        // 生成node的名字，比如"Player"
        if let bodyClassName = String.stringWithUTF8String(class_getName(body.node.classForCoder)){
            // 生成方法名，比如"visitPlayer"
            var contactSelectorString = "visit" + bodyClassName + "()"
            let selector = NSSelectorFromString(contactSelectorString)
            if self.respondsToSelector(selector){
                var control:UIControl = UIControl()
                control.sendAction(selector, to: self, forEvent: nil)
            }
        }
        
        
        
    }
}