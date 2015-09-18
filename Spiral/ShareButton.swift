//
//  ShareButton.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-7-16.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import SpriteKit

class ShareButton: SKSpriteNode {
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init() {
        let texture = SKTexture(imageNamed: "sharebtn")
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size() * 0.5)
        userInteractionEnabled = true
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let scene = self.scene as! GameScene
        let image = imageFromNode(scene)
        let url = NSURL(string: NSLocalizedString("https://itunes.apple.com/us/app/square-spiral/id920811081", comment: ""))
        let messageDiscription = String.localizedStringWithFormat(NSLocalizedString("I got %d points in Spiral. Come on with me!", comment: ""), Data.sharedData.score)
        
        let wechatSessionMessage = WeChatActivity.Message(title:NSLocalizedString("Square Spiral", comment: ""), description:NSLocalizedString(messageDiscription, comment: ""), thumbnail:UIImage(named: "shareThumb"), media: WeChatActivity.Message.Media.URL(url!))
        let wechatSessionActivity = WeChatActivity(scene: .Session, message: wechatSessionMessage)
        
        let wechatTimelineMessage = WeChatActivity.Message(title:NSLocalizedString(messageDiscription, comment: ""), description:"", thumbnail:UIImage(named: "shareThumb"), media: WeChatActivity.Message.Media.URL(url!))
        let wechatTimelineActivity = WeChatActivity(scene: .Timeline, message: wechatTimelineMessage)
        
        let activityItems = [image,messageDiscription]
        let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: [wechatSessionActivity, wechatTimelineActivity])
        (scene.view!.nextResponder() as! UIViewController).presentViewController(activityController, animated: true, completion: nil)
    }
}
