//
//  SendWX.h
//  Spiral
//
//  Created by 杨萧玉 on 14/10/21.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@interface SendWX : NSObject 
+ (void) sendImageContent:(UIImage *) image withScore:(NSString *)score;
+ (void) sendLinkContentWithImage:(UIImage *) image score:(NSString *)score;
@end
