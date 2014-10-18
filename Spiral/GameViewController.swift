//
//  GameViewController.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-7-12.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
//    class func unarchiveFromFile(file : NSString) -> SKNode? {
//        
//        let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks")
//        
//        var sceneData = NSData.dataWithContentsOfFile(path!, options: .DataReadingMappedIfSafe, error: nil)
//        var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
//        
//        archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
//        let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as GameScene
//        archiver.finishDecoding()
//        return scene
//    }
}

class GameViewController: UIViewController {

    var longPress:UILongPressGestureRecognizer!
    var tapWithOneFinger:UITapGestureRecognizer!
    var tapWithTwoFinger:UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure the view.
        let skView = self.view as SKView
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        longPress = UILongPressGestureRecognizer(target: self, action: Selector("handleLongPressFrom:"))
        tapWithOneFinger = UITapGestureRecognizer(target: self, action: Selector("handleTapWithOneFingerFrom:"))
        tapWithTwoFinger = UITapGestureRecognizer(target: self, action: Selector("handleTapWithTwoFingerFrom:"))
        tapWithTwoFinger.numberOfTouchesRequired = 2

        addGestureRecognizers()

        let scene = GameScene(size: skView.bounds.size)
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        skView.presentScene(scene)
        
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func handleLongPressFrom(recognizer:UILongPressGestureRecognizer) {
        if recognizer.state == .Began {
            ((self.view as SKView).scene as GameScene).pause()
        }
    }
    
    func handleTapWithOneFingerFrom(recognizer:UILongPressGestureRecognizer) {
        if recognizer.state == .Ended {
            ((self.view as SKView).scene as GameScene).tap()
        }
    }
    
    func handleTapWithTwoFingerFrom(recognizer:UILongPressGestureRecognizer) {
        if recognizer.state == .Ended {
            ((self.view as SKView).scene as GameScene).createReaper()
        }
    }
    
    func addGestureRecognizers(){
        let skView = self.view as SKView
        skView.addGestureRecognizer(longPress)
        skView.addGestureRecognizer(tapWithOneFinger)
        skView.addGestureRecognizer(tapWithTwoFinger)
    }
    
    func removeGestureRecognizers(){
        let skView = self.view as SKView
        skView.removeGestureRecognizer(longPress)
        skView.removeGestureRecognizer(tapWithOneFinger)
        skView.removeGestureRecognizer(tapWithTwoFinger)
    }
    
}
