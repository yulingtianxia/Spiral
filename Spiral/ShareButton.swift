//
//  ShareButton.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-7-16.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import SpriteKit

class ShareButton: SKLabelNode {
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init() {
        super.init()
        self.userInteractionEnabled = true
        setDefaultFont()
        self.text = NSLocalizedString("SHARE", comment: "")
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let lang = NSUserDefaults.standardUserDefaults().objectForKey("AppleLanguages")?.objectAtIndex(0) as! String
        let scene = self.scene as! GameScene
        let image = imageFromNode(scene)
        if lang == "zh-Hans" {
//            SendWX.sendImageContent(image, withScore: "\(Data.sharedData.score)")
            if !SendWX.sendLinkContentWithImage(image, score: "\(Data.sharedData.score)") {
                //微信不可用
                let alert = UIAlertController(title: "抱歉", message: "你没有安装微信", preferredStyle: .Alert)
                let action = UIAlertAction(title: "哎", style: .Default, handler: nil)
                alert.addAction(action)
                self.scene?.view?.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
            }
        }
        else{
            let text = String.localizedStringWithFormat(NSLocalizedString("I got %d points in Spiral. Come on with me! https://itunes.apple.com/us/app/square-spiral/id920811081", comment: ""), Data.sharedData.score)
            let activityItems = [image,text]
            let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            (scene.view!.nextResponder() as! UIViewController).presentViewController(activityController, animated: true, completion: nil)
        }
    }
}
