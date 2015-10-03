//
//  Data.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-7-15.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//
import UIKit

enum GameMode {
    case Ordinary
    case Zen
    case Maze
}

protocol DisplayData: class{
    func updateData()
    func levelUp()
    func gameOver()
    func restart()
    func disableButtons()
}

public class Data{
    
    private static let instance = Data()
    
    class var sharedData: Data {
        return instance
    }
    
    weak var display: DisplayData?
    
    var updateScore:Int = 5
    
    var autoRecord:Bool = true
    
    var currentMode: GameMode = .Ordinary
    
    public var score:Int = 0{
        willSet{
        if newValue>=updateScore{
            updateScore+=5 * ++level
        }
        }
        didSet{
            display?.updateData()
            if score >= 50{
                let achievement = GameKitHelper.sharedGameKitHelper.getAchievementForIdentifier(kget50PointsAchievementID)
                achievement.percentComplete = 100
                GameKitHelper.sharedGameKitHelper.updateAchievement(achievement, identifier: kget50PointsAchievementID)
            }
            if score >= 100{
                let achievement = GameKitHelper.sharedGameKitHelper.getAchievementForIdentifier(kget100PointsAchievementID)
                achievement.percentComplete = 100
                GameKitHelper.sharedGameKitHelper.updateAchievement(achievement, identifier: kget100PointsAchievementID)
            }
            if score >= 200{
                let achievement = GameKitHelper.sharedGameKitHelper.getAchievementForIdentifier(kget200PointsAchievementID)
                achievement.percentComplete = 100
                GameKitHelper.sharedGameKitHelper.updateAchievement(achievement, identifier: kget200PointsAchievementID)
            }
        }
    }
    
    var highScore:Int = 0
    
    var gameOver:Bool = false {
        willSet{
            if newValue {
                let standardDefaults = NSUserDefaults.standardUserDefaults()
                highScore = standardDefaults.integerForKey("highscore")
                if highScore < score {
                    highScore = score
                    standardDefaults.setInteger(score, forKey: "highscore")
                    standardDefaults.synchronize()
                }
                display?.gameOver()
            }
            else {
                display?.restart()
            }
        }
        didSet{
            sendDataToGameCenter()
        }
    }
    
    var level:Int = 1{
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
    
    var speedScale:CGFloat = 0
    
    var reaperNum:Int = 1{
        didSet{
            display?.updateData()
        }
    }
    
    func reset(){
        updateScore = 5
        score = 0
        level = 1
        speedScale = 0
        reaperNum = 1
    }
    
    private func sendDataToGameCenter(){
        GameKitHelper.sharedGameKitHelper.submitScore(Int64(score), identifier: kHighScoreLeaderboardIdentifier)
        GameKitHelper.sharedGameKitHelper.reportMultipleAchievements()
    }
}