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

func + (left: vector_int2, right: vector_int2) -> vector_int2 {
    return vector_int2(left.x + right.x, left.y + right.y)
}

private func imageWithView(view:UIView)->UIImage{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    view.drawViewHierarchyInRect(view.bounds,afterScreenUpdates:true)
    let img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


func imageFromNode(node:SKNode)->UIImage{
    if let tex = ((UIApplication.sharedApplication().delegate as! AppDelegate).window?.rootViewController?.view as! SKView).textureFromNode(node) {
        let view  = SKView(frame: CGRectMake(0, 0, tex.size().width, tex.size().height))
        let scene = SKScene(size: tex.size())
        let sprite  = SKSpriteNode(texture: tex)
        sprite.position = CGPointMake( CGRectGetMidX(view.frame), CGRectGetMidY(view.frame) );
        scene.addChild(sprite)
        view.presentScene(scene)
        return imageWithView(view)
    }
    return UIImage()
}