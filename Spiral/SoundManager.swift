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
    
    private lazy var bgMusicPlayer:AVAudioPlayer = {
        let backgroundFileName:String
        switch Data.currentMode {
        case .Ordinary:
            backgroundFileName = "bg_ordinary"
        case .Zen:
            backgroundFileName = "bg_zen"
        }
        if let bgMusicURL =  NSBundle.mainBundle().URLForResource(backgroundFileName, withExtension: "mp3") {
            return AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
        }
        return AVAudioPlayer()
    }()
    
    private lazy var jumpPlayer:AVAudioPlayer = {
        switch Data.currentMode {
        case .Ordinary:
            if let bgMusicURL =  NSBundle.mainBundle().URLForResource("jump_ordinary", withExtension: "mp3"){
                return AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
            }
        case .Zen:
            if let bgMusicURL =  NSBundle.mainBundle().URLForResource("jump_zen", withExtension: "wav"){
                return AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
            }
        }
        return AVAudioPlayer()
    }()
    
    private lazy var gameoverPlayer:AVAudioPlayer = {
        switch Data.currentMode {
        case .Ordinary:
            if let bgMusicURL =  NSBundle.mainBundle().URLForResource("gameover_ordinary", withExtension: "mp3"){
                return AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
            }
        case .Zen:
            if let bgMusicURL =  NSBundle.mainBundle().URLForResource("gameover_zen", withExtension: "wav"){
                return AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
            }
        }
        return AVAudioPlayer()
    }()
    
    private lazy var levelupPlayer:AVAudioPlayer = {
        switch Data.currentMode {
        case .Ordinary:
            if let bgMusicURL =  NSBundle.mainBundle().URLForResource("levelup_ordinary", withExtension: "mp3"){
                return AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
            }
        case .Zen:
            if let bgMusicURL =  NSBundle.mainBundle().URLForResource("levelup_zen", withExtension: "wav"){
                return AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
            }
        }
        return AVAudioPlayer()
    }()
    
    private lazy var scorePlayer:AVAudioPlayer = {
        switch Data.currentMode {
        case .Ordinary:
            if let bgMusicURL =  NSBundle.mainBundle().URLForResource("score_ordinary", withExtension: "mp3"){
                return AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
            }
        case .Zen:
            if let bgMusicURL =  NSBundle.mainBundle().URLForResource("score_zen", withExtension: "wav"){
                return AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
            }
        }
        return AVAudioPlayer()
    }()
    
    private lazy var shieldPlayer:AVAudioPlayer = {
        switch Data.currentMode {
        case .Ordinary:
            if let bgMusicURL =  NSBundle.mainBundle().URLForResource("shield_ordinary", withExtension: "wav"){
                return AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
            }
        case .Zen:
            if let bgMusicURL =  NSBundle.mainBundle().URLForResource("shield_zen", withExtension: "mp3"){
                return AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
            }
        }
        return AVAudioPlayer()
    }()
    
    private lazy var killerPlayer:AVAudioPlayer = {
        switch Data.currentMode {
        case .Ordinary:
            if let bgMusicURL =  NSBundle.mainBundle().URLForResource("killer_ordinary", withExtension: "wav"){
                return AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
            }
        case .Zen:
            if let bgMusicURL =  NSBundle.mainBundle().URLForResource("killer_zen", withExtension: "wav"){
                return AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
            }
        }
        return AVAudioPlayer()
    }()
    
    func playBackGround(){
        bgMusicPlayer.numberOfLoops = -1
        bgMusicPlayer.prepareToPlay()
        bgMusicPlayer.play()
    }
    
    func stopBackGround(){
        bgMusicPlayer.stop()
    }
    
    func pauseBackGround(){
        bgMusicPlayer.pause()
    }
    
    func resumeBackGround(){
        bgMusicPlayer.prepareToPlay()
    }
    
    func playJump(){
        jumpPlayer.play()
    }
    
    func playGameOver(){
//        gameoverPlayer.prepareToPlay()
        gameoverPlayer.play()
    }
    
    func playLevelUp(){
//        levelupPlayer.prepareToPlay()
        levelupPlayer.play()
    }
    
    func playScore(){
//        scorePlayer.prepareToPlay()
        scorePlayer.play()
    }
    
    func playShield(){
//        shieldPlayer.prepareToPlay()
        shieldPlayer.play()
    }
    
    func playKiller(){
//        killerPlayer.prepareToPlay()
        killerPlayer.play()
    }
}
