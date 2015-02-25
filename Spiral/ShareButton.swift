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
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        let lang = NSUserDefaults.standardUserDefaults().objectForKey("AppleLanguages")?.objectAtIndex(0) as! String
        let scene = self.scene as! GameScene
        let image = scene.imageFromNode(scene)
        if lang == "zh-Hans" {
//            SendWX.sendImageContent(image, withScore: "\(Data.score)")
            SendWX.sendLinkContentWithImage(image, score: "\(Data.score)")
        }
        else{
            let text = String.localizedStringWithFormat(NSLocalizedString("I got %d points in Spiral. Come on with me! https://itunes.apple.com/us/app/square-spiral/id920811081", comment: ""), Data.score)
            let activityItems = [image,text]
            let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            (scene.view!.nextResponder() as! UIViewController).presentViewController(activityController, animated: true, completion: nil)
        }
    }
}
