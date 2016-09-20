//
//  Extensions.swift
//  Spiral
//
//  Created by 杨萧玉 on 15/6/5.
//  Copyright (c) 2015年 杨萧玉. All rights reserved.
//

import SpriteKit

extension UIImage {
    class fileprivate func imageWithView(_ view:UIView)->UIImage{
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0);
        view.drawHierarchy(in: view.bounds,afterScreenUpdates:true)
        let img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return img!;
    }
    
    
    class func imageFromNode(_ node:SKNode)->UIImage{
        if let tex = ((UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.view as! SKView).texture(from: node) {
            let view  = SKView(frame: CGRect(x: 0, y: 0, width: tex.size().width, height: tex.size().height))
            let scene = SKScene(size: tex.size())
            let sprite  = SKSpriteNode(texture: tex)
            sprite.position = CGPoint( x: view.frame.midX, y: view.frame.midY );
            scene.addChild(sprite)
            view.presentScene(scene)
            return imageWithView(view)
        }
        return UIImage()
    }
}

extension SKScene {
    class func unarchiveFromFile(_ file:String) -> SKNode? {
        if let path = Bundle.main.path(forResource: file, ofType: "sks") {
            let sceneData = try! Foundation.Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let archiver = NSKeyedUnarchiver(forReadingWith: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! SKScene
            scene.size = (GameKitHelper.sharedGameKitHelper.getRootViewController()?.view.frame.size)!
            archiver.finishDecoding()
            for child in scene.children {
                if let sprite = child as? SKSpriteNode {
                    sprite.texture?.preload(completionHandler: { })
                }
            }
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
        let originalSelector = #selector(SKNode.addChild(_:))
        let swizzledSelector = #selector(SKNode.yxy_addChild(_:))
        let originalMethod = class_getInstanceMethod(cls, originalSelector)
        let swizzledMethod = class_getInstanceMethod(cls, swizzledSelector)
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    
    class func yxy_swizzleRemoveFromParent() {
        let cls = SKNode.self
        let originalSelector = #selector(SKNode.removeFromParent)
        let swizzledSelector = #selector(SKNode.yxy_removeFromParent)
        let originalMethod = class_getInstanceMethod(cls, originalSelector)
        let swizzledMethod = class_getInstanceMethod(cls, swizzledSelector)
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    
    func yxy_addChild(_ node: SKNode) {
        if node.parent == nil {
            self.yxy_addChild(node)
        }
        else {
            print("This node has already a parent!\(node.name)")
        }
    }
    
    func yxy_removeFromParent() {
        if parent != nil {
            DispatchQueue.main.async(execute: { () -> Void in
                self.yxy_removeFromParent()
            })
        }
        else {
            print("This node has no parent!\(name)")
        }
    }
    
}
