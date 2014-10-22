//
//  SendWX.m
//  Spiral
//
//  Created by 杨萧玉 on 14/10/21.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

#import "SendWX.h"
#import "WXApi.h"

@import UIKit;

@implementation SendWX

+ (void) sendImageContent:(UIImage *) image withScore:(NSString *)score
{
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"AppIcon"]];
    [message setTitle:[NSString stringWithFormat:@"我在Spiral游戏中得了%@分，快来超越我吧！https://itunes.apple.com/cn/app/square-spiral/id920811081",score]];
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = UIImagePNGRepresentation(image);
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
}

+ (void) sendLinkContentWithImage:(UIImage *) image score:(NSString *)score
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = [NSString stringWithFormat:@"我在Spiral游戏中得了%@分，快来超越我吧！",score];
    message.description = @"你想在永无止境的虚空中功成名就么？来挑战自我吧！看谁能坚持到底！";
    [message setThumbImage:[UIImage imageNamed:@"shareThumb"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = @"https://itunes.apple.com/cn/app/square-spiral/id920811081?l=zh&ls=1&mt=8";
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
}

@end
