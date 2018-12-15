//
//  WeChatActivity.swift
//  Spiral
//
//  Created by 杨萧玉 on 15/9/18.
//  Copyright © 2015年 杨萧玉. All rights reserved.
//

import UIKit

class WeChatActivity: UIActivity {
    
    enum Scene {
        case session    // 聊天界面
        case timeline   // 朋友圈
        
        var value: Int32 {
            switch self {
            case .session:
                return 0
            case .timeline:
                return 1
            }
        }
        
        var activityType: String {
            switch self {
            case .session:
                return "com.yulingtianxia.spiral.shareToWeChatSession"
            case .timeline:
                return "com.yulingtianxia.spiral.shareToWeChatTimeline"
            }
        }
        
        var activityTitle: String {
            switch self {
            case .session:
                return NSLocalizedString("WeChat Session", comment: "")
            case .timeline:
                return NSLocalizedString("WeChat Timeline", comment: "")
            }
        }
        
        var activityImage: UIImage? {
            switch self {
            case .session:
                return UIImage(named: "wechat_session")
            case .timeline:
                return UIImage(named: "wechat_timeline")
            }
        }
    }
    
    struct Message {
        let title: String?
        let description: String?
        let thumbnail: UIImage?
        
        enum Media {
            case url(Foundation.URL)
            case image(UIImage)
        }
        
        let media: Media
    }
    
    let scene: Scene
    let message: Message
    
    init(scene: Scene, message: Message) {
        self.scene = scene
        self.message = message
        
        super.init()
    }
    
    override class var activityCategory : UIActivity.Category {
        return .share
    }
    
    override var activityType : UIActivity.ActivityType? {
        return UIActivity.ActivityType(scene.activityType)
    }
    
    override var activityTitle : String? {
        return scene.activityTitle
    }
    
    override var activityImage : UIImage? {
        return scene.activityImage
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        
        if WXApi.isWXAppInstalled() && WXApi.isWXAppSupport() {
            return true
        }
        
        return false
    }
    
    override func perform() {
        
        let request = SendMessageToWXReq()
        
        request.scene = scene.value
        
        let message = WXMediaMessage()
        
        message.title = self.message.title
        message.description = self.message.description
        message.setThumbImage(self.message.thumbnail)
        
        switch self.message.media {
            
        case .url(let URL):
            let webObject = WXWebpageObject()
            webObject.webpageUrl = URL.absoluteString
            message.mediaObject = webObject
            
        case .image(let image):
            let imageObject = WXImageObject()
            imageObject.imageData = image.jpegData(compressionQuality: 1)
            message.mediaObject = imageObject
        }
        
        request.message = message
        
        WXApi.send(request)
        
        activityDidFinish(true)
    }
}
