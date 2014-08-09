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
    var bgMusicPlayer = AVAudioPlayer()
    func playBackGround(){
        
        if var bgMusicURL =  NSBundle.mainBundle().URLForResource("pew-pew-lei", withExtension: "caf"){
            bgMusicPlayer=AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
            bgMusicPlayer.numberOfLoops = -1
            bgMusicPlayer.prepareToPlay()
            bgMusicPlayer.play()
        }
    }
    func stopBackGround(){
        bgMusicPlayer.stop()
    }
}
