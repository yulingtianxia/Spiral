//
//  Data.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-7-15.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//
import Foundation
struct Data{
    static var display:DisplayData?
    static var updateScore:Int = 5
    static var score:Int = 0{
        willSet{
        if newValue>=updateScore{
        updateScore+=5 * ++level
        }
        if newValue >= 50{
        var achievement = GameKitHelper.sharedGameKitHelper().getAchievementForIdentifier(kget50PointsAchievementID)
        achievement.percentComplete = 100
        GameKitHelper.sharedGameKitHelper().updateAchievement(achievement, identifier: kget50PointsAchievementID)
    }
        if newValue >= 100{
        var achievement = GameKitHelper.sharedGameKitHelper().getAchievementForIdentifier(kget100PointsAchievementID)
        achievement.percentComplete = 100
        GameKitHelper.sharedGameKitHelper().updateAchievement(achievement, identifier: kget100PointsAchievementID)
        }
        if newValue >= 200{
        var achievement = GameKitHelper.sharedGameKitHelper().getAchievementForIdentifier(kget200PointsAchievementID)
        achievement.percentComplete = 100
        GameKitHelper.sharedGameKitHelper().updateAchievement(achievement, identifier: kget200PointsAchievementID)
        }
        }
        didSet{
            display?.updateData()
        }
    }
    static var highScore:Int = 0
    static var gameOver:Bool = false {
        willSet{
        if newValue {
        let standardDefaults = NSUserDefaults.standardUserDefaults()
        Data.highScore = standardDefaults.integerForKey("highscore")
        if Data.highScore < Data.score {
        Data.highScore = Data.score
        standardDefaults.setInteger(Data.score, forKey: "highscore")
        standardDefaults.synchronize()
        sendDataToGameCenter()
        }
        display?.gameOver()
    }
        else {
        display?.restart()
        }
        }
        didSet{
            
        }
    }
    static var level:Int = 1{
        willSet{
        speedScale = 1/CGFloat(newValue)
        if newValue != 1{
        display?.levelUp()
        }
        reaperNum++
        }
        didSet{
            display?.updateData()
            
        }
    }
    static var speedScale:CGFloat = 0
    static var reaperNum:Int = 1{
        didSet{
            display?.updateData()
        }
    }
    static func restart(){
        Data.updateScore = 5
        Data.score = 0
        Data.level = 1
        Data.speedScale = 0
        Data.reaperNum = 1
    }
    
    private static func sendDataToGameCenter(){
        GameKitHelper.sharedGameKitHelper().submitScore(Int64(Data.score), identifier: kHighScoreLeaderboardIdentifier)
        GameKitHelper.sharedGameKitHelper().reportMultipleAchievements()
    }
}