//
//  GameKitHelper.m
//  ColorAtom
//
//  Created by 杨萧玉 on 14-9-12.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

#import "GameKitHelper.h"
#import <EXTScope.h>
#import "Spiral-swift.h"


@interface GameKitHelper () <GKGameCenterControllerDelegate> {
    BOOL _gameCenterFeaturesEnabled;
}
@end

@implementation GameKitHelper
@synthesize achievementsDictionary;

#pragma mark Singleton stuff
+(id) sharedGameKitHelper {
    static GameKitHelper *sharedGameKitHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGameKitHelper =
        [[GameKitHelper alloc] init];
    });
    return sharedGameKitHelper;
}

-(instancetype) init{
    if (self = [super init]) {
        achievementsDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}
#pragma mark Player Authentication

-(void) authenticateLocalPlayer {
    
    GKLocalPlayer* localPlayer =
    [GKLocalPlayer localPlayer];
    @weakify(localPlayer)
    localPlayer.authenticateHandler =
    ^(UIViewController *viewController,
      NSError *error) {
        @strongify(localPlayer)
        [self setLastError:error];
        if (localPlayer.authenticated) {
            _gameCenterFeaturesEnabled = YES;
            if (_submitScoreWithCompletionHandler) {
                _submitScoreWithCompletionHandler(YES);
            }
            [self loadAchievements];
        } else if(viewController) {
            //TODO:palse
            [self pause];
            [self presentViewController:viewController];
        } else {
            _gameCenterFeaturesEnabled = NO;
            if (_submitScoreWithCompletionHandler) {
                _submitScoreWithCompletionHandler(NO);
            }
        }
    };
}

#pragma mark Property setters

-(void) setLastError:(NSError*)error {
    _lastError = [error copy];
    if (_lastError) {
        NSLog(@"GameKitHelper ERROR: %@", [[_lastError userInfo]
                                           description]);
    }
}

#pragma mark UIViewController stuff

-(UIViewController*) getRootViewController {
    return [UIApplication
            sharedApplication].keyWindow.rootViewController;
}

-(void)presentViewController:(UIViewController*)vc {
    UIViewController* rootVC = [self getRootViewController];
    [rootVC presentViewController:vc animated:YES
                       completion:nil];
}

#pragma mark GameKitHelperProtocol
-(void) submitScore:(int64_t)score
           identifier:(NSString*)identifier {
    //1: Check if Game Center
    //   features are enabled
    if (!_gameCenterFeaturesEnabled) {
        //@"Player not authenticated"
        if (_submitScoreWithCompletionHandler) {
            _submitScoreWithCompletionHandler(NO);
        }
        return;
    }
    
    //2: Create a GKScore object
    GKScore* gkScore = [[GKScore alloc] initWithLeaderboardIdentifier:identifier];
    //3: Set the score value
    gkScore.value = score;
    
    //4: Send the score to Game Center
    [GKScore reportScores:@[gkScore] withCompletionHandler:
     ^(NSError* error) {
         
         [self setLastError:error];
         
         BOOL success = (error == nil);
         if (_submitScoreWithCompletionHandler) {
             _submitScoreWithCompletionHandler(success);
         }
         if ([_delegate
              respondsToSelector:
              @selector(onScoresSubmitted:)]) {
             
             [_delegate onScoresSubmitted:success];
         }
     }];
}

-(void)pause{
    [[NSNotificationCenter defaultCenter] postNotificationName:WantGamePauseNotification object:nil];
//    GameViewController* gvc = (GameViewController*)[self getRootViewController];
//    [((GameScene*)(((SKView*)gvc.view).scene)) pause];
}

#pragma mark Achievements Methods
- (void) loadAchievements
{
    [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error)
     {
         if (error == nil)
         {
             for (GKAchievement* achievement in achievements)
                 [achievementsDictionary setObject: achievement forKey: achievement.identifier];
         }
     }];
}

- (GKAchievement*) getAchievementForIdentifier: (NSString*) identifier
{
    GKAchievement *achievement = [achievementsDictionary objectForKey:identifier];
    if (achievement == nil)
    {
        achievement = [[GKAchievement alloc] initWithIdentifier:identifier];
        [achievementsDictionary setObject:achievement forKey:achievement.identifier];
    }
    return achievement;
}

- (void) updateAchievement:(GKAchievement*) achievement Identifier: (NSString*) identifier
{
    if (achievement)
    {
        [self.achievementsDictionary setObject:achievement forKey:identifier];
    }
}

- (void) reportMultipleAchievements
{
    
    [GKAchievement reportAchievements:[self.achievementsDictionary allValues]  withCompletionHandler:^(NSError *error)
     {
         if (error != nil)
         {
             NSLog(@"Error in reporting achievements: %@", error);
         }
     }];
}

- (void) showLeaderboard
{
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    if (gameCenterController != nil)
    {
        [self pause];
        gameCenterController.gameCenterDelegate = self;
        gameCenterController.viewState = GKGameCenterViewControllerStateAchievements;
        [self presentViewController: gameCenterController];
    }
}

#pragma mark GKGameCenterControllerDelegate
- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [[self getRootViewController] dismissViewControllerAnimated:YES completion:nil];
}

@end
