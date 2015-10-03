//
//  SoundManager.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-7-28.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation
class SoundManager: SKNode {
    
    private var bgMusicPlayer:AVAudioPlayer?
    
    func playBackGround(){
        let backgroundFileName:String
        switch Data.sharedData.currentMode {
        case .Ordinary:
            backgroundFileName = "bg_ordinary"
        case .Zen:
            backgroundFileName = "bg_zen"
        case .Maze:
            backgroundFileName = "bg_maze"
        }
        if let bgMusicURL =  NSBundle.mainBundle().URLForResource(backgroundFileName, withExtension: "mp3") {
            do {
                bgMusicPlayer = try AVAudioPlayer(contentsOfURL: bgMusicURL)
            } catch _ {
                bgMusicPlayer = nil
            }
        }
        bgMusicPlayer?.numberOfLoops = -1
        bgMusicPlayer?.prepareToPlay()
        bgMusicPlayer?.play()
    }
    
    func stopBackGround(){
        bgMusicPlayer?.stop()
    }
    
    func pauseBackGround(){
        bgMusicPlayer?.pause()
    }
    
    func resumeBackGround(){
        bgMusicPlayer?.prepareToPlay()
        bgMusicPlayer?.playAtTime(bgMusicPlayer!.deviceCurrentTime)
    }
    
    func playJump(){
        switch Data.sharedData.currentMode {
        case .Ordinary:
            runAction(SKAction.playSoundFileNamed("jump_ordinary.wav", waitForCompletion: true))
        case .Zen:
            runAction(SKAction.playSoundFileNamed("jump_zen.wav", waitForCompletion: true))
        case .Maze:
            runAction(SKAction.playSoundFileNamed("jump_maze.wav", waitForCompletion: true))
        }
    }
    
    func playGameOver(){
        switch Data.sharedData.currentMode {
        case .Ordinary:
            runAction(SKAction.playSoundFileNamed("gameover_ordinary.wav", waitForCompletion: true))
        case .Zen:
            runAction(SKAction.playSoundFileNamed("gameover_zen.wav", waitForCompletion: true))
        case .Maze:
            runAction(SKAction.playSoundFileNamed("gameover_maze.wav", waitForCompletion: true))
        }
    }
    
    func playLevelUp(){
        switch Data.sharedData.currentMode {
        case .Ordinary:
            runAction(SKAction.playSoundFileNamed("levelup_ordinary.wav", waitForCompletion: true))
        case .Zen:
            runAction(SKAction.playSoundFileNamed("levelup_zen.wav", waitForCompletion: true))
        case .Maze:
            runAction(SKAction.playSoundFileNamed("levelup_maze.wav", waitForCompletion: true))
        }
    }
    
    func playScore(){
        switch Data.sharedData.currentMode {
        case .Ordinary:
            runAction(SKAction.playSoundFileNamed("score_ordinary.wav", waitForCompletion: true))
        case .Zen:
            runAction(SKAction.playSoundFileNamed("score_zen.wav", waitForCompletion: true))
        case .Maze:
            runAction(SKAction.playSoundFileNamed("score_maze.wav", waitForCompletion: true))
        }
    }
    
    func playShield(){
        switch Data.sharedData.currentMode {
        case .Ordinary:
            runAction(SKAction.playSoundFileNamed("shield_ordinary.wav", waitForCompletion: true))
        case .Zen:
            runAction(SKAction.playSoundFileNamed("shield_zen.wav", waitForCompletion: true))
        case .Maze:
            runAction(SKAction.playSoundFileNamed("shield_maze.wav", waitForCompletion: true))
        }
    }
    
    func playKiller(){
        switch Data.sharedData.currentMode {
        case .Ordinary:
            runAction(SKAction.playSoundFileNamed("killer_ordinary.wav", waitForCompletion: true))
        case .Zen:
            runAction(SKAction.playSoundFileNamed("killer_zen.wav", waitForCompletion: true))
        case .Maze:
            runAction(SKAction.playSoundFileNamed("killer_maze.wav", waitForCompletion: true))
        }
    }
}
