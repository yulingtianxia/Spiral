//
//  GameKitHelper.h
//  ColorAtom
//
//  Created by 杨萧玉 on 14-9-12.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GameKit;

@protocol GameKitHelperProtocol<NSObject>
-(void) onScoresSubmitted:(bool)success;
@end

@interface GameKitHelper : NSObject

@property (nonatomic,assign) id<GameKitHelperProtocol> delegate;
@property (nonatomic, readonly) NSError* lastError;

+ (id) sharedGameKitHelper;
-(void) authenticateLocalPlayer;
-(void) submitScore:(int64_t)score identifier:(NSString*)category;
@end
