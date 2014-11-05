//
//  GameViewController.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-7-12.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import UIKit
import SpriteKit

extension SKScene {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as SKScene
            scene.size = GameKitHelper.sharedGameKitHelper().getRootViewController().view.frame.size
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

extension SKLabelNode {
    func setDefaultFont(){
        self.fontName = NSLocalizedString("HelveticaNeue-UltraLight", comment: "")
    }
}

class GameViewController: UIViewController {

    var longPress:UILongPressGestureRecognizer!
    var tapWithOneFinger:UITapGestureRecognizer!
    var tapWithTwoFinger:UITapGestureRecognizer!
    var pan:UIPanGestureRecognizer!
    var swipeRight:UISwipeGestureRecognizer!
    var pinch:UIPinchGestureRecognizer!
    
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
        pan = UIPanGestureRecognizer(target: self, action: Selector("handlePanFrom:"))
        pan.maximumNumberOfTouches = 1
        swipeRight = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipeFrom:"))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        swipeRight.numberOfTouchesRequired = 2
        
        pinch = UIPinchGestureRecognizer(target: self, action: Selector("handlePinchFrom:"))
        
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
            ((self.view as SKView).scene as? GameScene)?.pause()
        }
    }
    
    func handleTapWithOneFingerFrom(recognizer:UILongPressGestureRecognizer) {
        if recognizer.state == .Ended {
            ((self.view as SKView).scene as? GameScene)?.tap()
        }
    }
    
    func handleTapWithTwoFingerFrom(recognizer:UILongPressGestureRecognizer) {
        if recognizer.state == .Ended {
//            ((self.view as SKView).scene as? GameScene)?.createReaper()
        }
    }
    
    func handlePanFrom(recognizer:UIPanGestureRecognizer) {
        if recognizer.state == .Changed {
            ((self.view as SKView).scene as? HelpScene)?.lightWithFinger(recognizer.locationInView(self.view))
        }
        else if recognizer.state == .Ended {
            ((self.view as SKView).scene as? HelpScene)?.turnOffLight()
        }
    }
    
    func handleSwipeFrom(recognizer:UISwipeGestureRecognizer) {
        if recognizer.direction == .Right {
            ((self.view as SKView).scene as? HelpScene)?.back()
        }
    }
    
    func handlePinchFrom(recognizer:UIPinchGestureRecognizer) {
        if recognizer.state == .Began {
            if recognizer.scale > 1 {
                ((self.view as SKView).scene as? GameScene)?.createReaper()
            }
            else {
                ((self.view as SKView).scene as? GameScene)?.allShapesJumpIn()
            }
        }
    }
    
    func addGestureRecognizers(){
        let skView = self.view as SKView
        skView.addGestureRecognizer(longPress)
        skView.addGestureRecognizer(tapWithOneFinger)
        skView.addGestureRecognizer(tapWithTwoFinger)
        skView.addGestureRecognizer(pan)
        skView.addGestureRecognizer(swipeRight)
        skView.addGestureRecognizer(pinch)
    }
    
    func removeGestureRecognizers(){
        let skView = self.view as SKView
        skView.removeGestureRecognizer(longPress)
        skView.removeGestureRecognizer(tapWithOneFinger)
        skView.removeGestureRecognizer(tapWithTwoFinger)
        skView.removeGestureRecognizer(pan)
        skView.removeGestureRecognizer(swipeRight)
        skView.removeGestureRecognizer(pinch)
    }
    
}
