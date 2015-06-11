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
    private var jumpPlayer:AVAudioPlayer?
    private var gameoverPlayer:AVAudioPlayer?
    private var levelupPlayer:AVAudioPlayer?
    private var scorePlayer:AVAudioPlayer?
    private var shieldPlayer:AVAudioPlayer?
    private var killerPlayer:AVAudioPlayer?
    func playBackGround(){
        let backgroundFileName:String
        switch Data.sharedData.currentMode {
        case .Ordinary:
            backgroundFileName = "bg_ordinary"
        case .Zen:
            backgroundFileName = "bg_zen"
        }
        if let bgMusicURL =  NSBundle.mainBundle().URLForResource(backgroundFileName, withExtension: "mp3") {
            bgMusicPlayer = AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
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
        let backgroundFileName:String
        switch Data.sharedData.currentMode {
        case .Ordinary:
            if let bgMusicURL =  NSBundle.mainBundle().URLForResource("jump_ordinary", withExtension: "mp3"){
                jumpPlayer = AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
            }
        case .Zen:
            if let bgMusicURL =  NSBundle.mainBundle().URLForResource("jump_zen", withExtension: "wav"){
                jumpPlayer = AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
            }
        }
        jumpPlayer?.play()
    }
    
    func playGameOver(){
        switch Data.sharedData.currentMode {
        case .Ordinary:
            if let bgMusicURL =  NSBundle.mainBundle().URLForResource("gameover_ordinary", withExtension: "mp3"){
                gameoverPlayer = AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
            }
        case .Zen:
            if let bgMusicURL =  NSBundle.mainBundle().URLForResource("gameover_zen", withExtension: "wav"){
                gameoverPlayer = AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
            }
        }
        gameoverPlayer?.play()
    }
    
    func playLevelUp(){
        switch Data.sharedData.currentMode {
        case .Ordinary:
            if let bgMusicURL =  NSBundle.mainBundle().URLForResource("levelup_ordinary", withExtension: "mp3"){
                levelupPlayer = AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
            }
        case .Zen:
            if let bgMusicURL =  NSBundle.mainBundle().URLForResource("levelup_zen", withExtension: "wav"){
                levelupPlayer = AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
            }
        }
        levelupPlayer?.play()
    }
    
    func playScore(){
        switch Data.sharedData.currentMode {
        case .Ordinary:
            if let bgMusicURL =  NSBundle.mainBundle().URLForResource("score_ordinary", withExtension: "mp3"){
                scorePlayer = AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
            }
        case .Zen:
            if let bgMusicURL =  NSBundle.mainBundle().URLForResource("score_zen", withExtension: "wav"){
                scorePlayer = AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
            }
        }
        scorePlayer?.play()
    }
    
    func playShield(){
        switch Data.sharedData.currentMode {
        case .Ordinary:
            if let bgMusicURL =  NSBundle.mainBundle().URLForResource("shield_ordinary", withExtension: "wav"){
                shieldPlayer = AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
            }
        case .Zen:
            if let bgMusicURL =  NSBundle.mainBundle().URLForResource("shield_zen", withExtension: "mp3"){
                shieldPlayer = AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
            }
        }
        shieldPlayer?.play()
    }
    
    func playKiller(){
        switch Data.sharedData.currentMode {
        case .Ordinary:
            if let bgMusicURL =  NSBundle.mainBundle().URLForResource("killer_ordinary", withExtension: "wav"){
                killerPlayer = AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
            }
        case .Zen:
            if let bgMusicURL =  NSBundle.mainBundle().URLForResource("killer_zen", withExtension: "wav"){
                killerPlayer = AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
            }
        }
        killerPlayer?.play()
    }
}
