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
        if newValue==updateScore{
            updateScore+=5 * ++level
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
            println(Data.score)
            println(Data.highScore)
            Data.highScore = standardDefaults.integerForKey("highscore")
            println(Data.highScore)
            if Data.highScore < Data.score {
                Data.highScore = Data.score
                standardDefaults.setInteger(Data.score, forKey: "highscore")
                standardDefaults.synchronize()
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
        speedScale = Float(newValue)*0.1
        if newValue != 1{
            display?.levelUp()
        }
    }
    didSet{
        display?.updateData()
        
    }
    }
    static var speedScale:Float = 0{
    willSet{
        
    }
    didSet{
        
    }
    }
    
    static func restart(){
        Data.updateScore = 5
        Data.score = 0
        Data.level = 1
        Data.speedScale = 0
    }
}