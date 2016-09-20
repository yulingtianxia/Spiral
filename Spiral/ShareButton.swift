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
        super.init(texture: texture, color: UIColor.clear, size: texture.size() * 0.6)
        isUserInteractionEnabled = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let image = UIImage.imageFromNode(scene!)
        let url = URL(string: NSLocalizedString("https://itunes.apple.com/us/app/square-spiral/id920811081", comment: ""))
        let messageDiscription = String.localizedStringWithFormat(NSLocalizedString("I got %d points in Spiral. Come on with me!", comment: ""), Data.sharedData.score)
        
        let wechatSessionMessage = WeChatActivity.Message(title:NSLocalizedString("Square Spiral", comment: ""), description:NSLocalizedString(messageDiscription, comment: ""), thumbnail:UIImage(named: "shareThumb"), media: WeChatActivity.Message.Media.url(url!))
        let wechatSessionActivity = WeChatActivity(scene: .session, message: wechatSessionMessage)
        
        let wechatTimelineMessage = WeChatActivity.Message(title:NSLocalizedString(messageDiscription, comment: ""), description:"", thumbnail:UIImage(named: "shareThumb"), media: WeChatActivity.Message.Media.url(url!))
        let wechatTimelineActivity = WeChatActivity(scene: .timeline, message: wechatTimelineMessage)
        
        let activityItems = [image, messageDiscription, url!.absoluteString] as [Any]
        let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: [wechatSessionActivity, wechatTimelineActivity])
        (scene!.view!.next as! UIViewController).present(activityController, animated: true, completion: nil)
    }
}
