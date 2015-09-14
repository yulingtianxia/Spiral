//
//  Extensions.swift
//  Spiral
//
//  Created by 杨萧玉 on 15/6/5.
//  Copyright (c) 2015年 杨萧玉. All rights reserved.
//

import SpriteKit

extension SKScene {
    class func unarchiveFromFile(file:String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            let sceneData = try! NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe)
            let archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! SKScene
            scene.size = (GameKitHelper.sharedGameKitHelper.getRootViewController()?.view.frame.size)!
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

extension SKLabelNode {
    func setDefaultFont(){
        self.fontName = NSLocalizedString("HelveticaNeue-Thin", comment: "")
    }
}

extension SKNode {
    
    class func yxy_swizzleAddChild() {
        let cls = SKNode.self
        let originalSelector = Selector("addChild:")
        let swizzledSelector = Selector("yxy_addChild:")
        let originalMethod = class_getInstanceMethod(cls, originalSelector)
        let swizzledMethod = class_getInstanceMethod(cls, swizzledSelector)
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    
    class func yxy_swizzleRemoveFromParent() {
        let cls = SKNode.self
        let originalSelector = Selector("removeFromParent")
        let swizzledSelector = Selector("yxy_removeFromParent")
        let originalMethod = class_getInstanceMethod(cls, originalSelector)
        let swizzledMethod = class_getInstanceMethod(cls, swizzledSelector)
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    
    func yxy_addChild(node: SKNode) {
        if node.parent == nil {
            self.yxy_addChild(node)
        }
        else {
            print("This node has already a parent!\(node.name)")
        }
    }
    
    func yxy_removeFromParent() {
        if parent != nil {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.yxy_removeFromParent()
            })
        }
        else {
            print("This node has no parent!\(name)")
        }
    }
    
}
