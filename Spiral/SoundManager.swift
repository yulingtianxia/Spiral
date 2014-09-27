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
    private var bgMusicPlayer:AVAudioPlayer!
    private var jumpPlayer:AVAudioPlayer!
    private var gameoverPlayer:AVAudioPlayer!
    private var levelupPlayer:AVAudioPlayer!
    private var scorePlayer:AVAudioPlayer!
    private var shieldPlayer:AVAudioPlayer!
    func playBackGround(){
        if let bgMusicURL =  NSBundle.mainBundle().URLForResource("bg", withExtension: "mp3"){
            bgMusicPlayer=AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
            bgMusicPlayer.numberOfLoops = -1
            bgMusicPlayer.prepareToPlay()
            bgMusicPlayer.play()
        }
    }
    func stopBackGround(){
        bgMusicPlayer.stop()
    }
    func playJump(){
        if let bgMusicURL =  NSBundle.mainBundle().URLForResource("jump", withExtension: "mp3"){
            jumpPlayer=AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
            jumpPlayer.prepareToPlay()
            jumpPlayer.play()
        }
    }
    func playGameOver(){
        if let bgMusicURL =  NSBundle.mainBundle().URLForResource("gameover", withExtension: "mp3"){
            gameoverPlayer=AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
            gameoverPlayer.prepareToPlay()
            gameoverPlayer.play()
        }
    }
    func playLevelUp(){
        if let bgMusicURL =  NSBundle.mainBundle().URLForResource("levelup", withExtension: "mp3"){
            levelupPlayer=AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
            levelupPlayer.prepareToPlay()
            levelupPlayer.play()
        }
    }
    func playScore(){
        if let bgMusicURL =  NSBundle.mainBundle().URLForResource("score", withExtension: "mp3"){
            scorePlayer=AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
            scorePlayer.prepareToPlay()
            scorePlayer.play()
        }
    }
    func playShield(){
        if let bgMusicURL =  NSBundle.mainBundle().URLForResource("shield", withExtension: "wav"){
            shieldPlayer=AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
            shieldPlayer.prepareToPlay()
            shieldPlayer.play()
        }
    }
}
