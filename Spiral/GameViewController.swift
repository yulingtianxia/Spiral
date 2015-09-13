//
//  GameViewController.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-7-12.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import UIKit
import SpriteKit

public class GameViewController: UIViewController, RPPreviewViewControllerDelegate {

    var longPress:UILongPressGestureRecognizer!
    var tapWithOneFinger:UITapGestureRecognizer!
    var tapWithTwoFinger:UITapGestureRecognizer!
    var pan:UIPanGestureRecognizer!
//    var swipeRight:UISwipeGestureRecognizer!
    var pinch:UIPinchGestureRecognizer!
    var screenEdgePanRight:UIScreenEdgePanGestureRecognizer!
    var previewViewController:RPPreviewViewController?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Configure the view.
        let skView = self.view as! SKView
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        longPress = UILongPressGestureRecognizer(target: self, action: Selector("handleLongPressGesture:"))
        tapWithOneFinger = UITapGestureRecognizer(target: self, action: Selector("handleTapWithOneFingerGesture:"))
        tapWithTwoFinger = UITapGestureRecognizer(target: self, action: Selector("handleTapWithTwoFingerGesture:"))
        tapWithTwoFinger.numberOfTouchesRequired = 2
        pan = UIPanGestureRecognizer(target: self, action: Selector("handlePanGesture:"))
        pan.maximumNumberOfTouches = 1
//        swipeRight = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipeGesture:"))
//        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
//        swipeRight.numberOfTouchesRequired = 2
        
        pinch = UIPinchGestureRecognizer(target: self, action: Selector("handlePinchGesture:"))
        screenEdgePanRight = UIScreenEdgePanGestureRecognizer(target: self, action: Selector("handleEdgePanGesture:"))
        screenEdgePanRight.edges = UIRectEdge.Left
        
//        addGestureRecognizers()
        let scene = MainScene(size: skView.bounds.size)
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        skView.presentScene(scene)
        
    }

    override public func shouldAutorotate() -> Bool {
        return true
    }

    override public func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return UIInterfaceOrientationMask.AllButUpsideDown
        } else {
            return UIInterfaceOrientationMask.All
        }
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override public func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: - handle gestures
    func handleLongPressGesture(recognizer:UILongPressGestureRecognizer) {
        if recognizer.state == .Began {
            ((self.view as! SKView).scene as? GameScene)?.pause()
        }
    }
    
    func handleTapWithOneFingerGesture(recognizer:UILongPressGestureRecognizer) {
        if recognizer.state == .Ended {
            ((self.view as! SKView).scene as? GameScene)?.tap()
        }
    }
    
    func handleTapWithTwoFingerGesture(recognizer:UILongPressGestureRecognizer) {
        if recognizer.state == .Ended {
//            ((self.view as! SKView).scene as? OrdinaryModeScene)?.createReaper()
        }
    }
    
    func handlePanGesture(recognizer:UIPanGestureRecognizer) {
        if recognizer.state == .Changed {
            ((self.view as! SKView).scene as? OrdinaryHelpScene)?.lightWithFinger(recognizer.locationInView(self.view))
            ((self.view as! SKView).scene as? ZenHelpScene)?.lightWithFinger(recognizer.locationInView(self.view))
        }
        else if recognizer.state == .Ended {
            ((self.view as! SKView).scene as? OrdinaryHelpScene)?.turnOffLight()
            ((self.view as! SKView).scene as? ZenHelpScene)?.turnOffLight()
        }
    }
    
    func handleSwipeGesture(recognizer:UISwipeGestureRecognizer) {
        if recognizer.direction == .Right {
            ((self.view as! SKView).scene as? OrdinaryHelpScene)?.back()
            ((self.view as! SKView).scene as? ZenHelpScene)?.back()
        }
    }
    
    func handlePinchGesture(recognizer:UIPinchGestureRecognizer) {
        if recognizer.state == .Began {
            if recognizer.scale > 1 {
                ((self.view as! SKView).scene as? GameScene)?.createReaper()
            }
            else {
                ((self.view as! SKView).scene as? GameScene)?.allShapesJumpIn()
            }
        }
    }
    
    func handleEdgePanGesture(recognizer:UIPinchGestureRecognizer) {
        if recognizer.state == .Ended {
            let scene = (self.view as! SKView).scene
            if let scene = scene as? OrdinaryHelpScene {
                scene.back()
            }
            else if let scene = scene as? ZenHelpScene {
                scene.back()
            }
            else if let scene = scene as? GameScene {
                let skView = view as! SKView
                Data.sharedData.display = nil
                Data.sharedData.gameOver = true
                Data.sharedData.reset()
                scene.soundManager.stopBackGround()
                stopRecord()
                let scene = MainScene(size: skView.bounds.size)
                let push = SKTransition.pushWithDirection(SKTransitionDirection.Right, duration: 1)
                push.pausesIncomingScene = false
                skView.presentScene(scene, transition: push)
                removeGestureRecognizers()
            }
        }
    }
    
    // MARK: - add&remove gesture recognizers
    func addGestureRecognizers() {
        let skView = self.view as! SKView
        skView.addGestureRecognizer(longPress)
        skView.addGestureRecognizer(tapWithOneFinger)
        skView.addGestureRecognizer(tapWithTwoFinger)
        skView.addGestureRecognizer(pan)
//        skView.addGestureRecognizer(swipeRight)
        skView.addGestureRecognizer(pinch)
        skView.addGestureRecognizer(screenEdgePanRight)
    }
    
    func removeGestureRecognizers() {
        let skView = self.view as! SKView
        skView.removeGestureRecognizer(longPress)
        skView.removeGestureRecognizer(tapWithOneFinger)
        skView.removeGestureRecognizer(tapWithTwoFinger)
        skView.removeGestureRecognizer(pan)
//        skView.removeGestureRecognizer(swipeRight)
        skView.removeGestureRecognizer(pinch)
        skView.removeGestureRecognizer(screenEdgePanRight)
    }
    
    // MARK: - record game
    
    func startRecordWithHandler(handler:() -> Void) {
        RPScreenRecorder.sharedRecorder().startRecordingWithMicrophoneEnabled(true) { (error) -> Void in
            
            if error != nil {
                //TODO: 提示错误,无法录制
            }
            else{
                handler()
            }
        }
    }
    
    func stopRecord() {
        RPScreenRecorder.sharedRecorder().stopRecordingWithHandler({ (previewViewController, ErrorType) -> Void in
            self.previewViewController = previewViewController
            previewViewController?.previewControllerDelegate = self
        })
    }
    
    func discardRecordWithHandler(handler:() -> Void) {
        RPScreenRecorder.sharedRecorder().discardRecordingWithHandler(handler)
    }
    
    func playRecord() {
        guard let previewViewController = previewViewController else { fatalError("The user requested playback, but a valid preview controller does not exist.") }
        previewViewController.modalPresentationStyle = UIModalPresentationStyle.FullScreen
        presentViewController(previewViewController, animated: true, completion:nil)
    }
    
    // MARK: - RPPreviewViewControllerDelegate
    public func previewControllerDidFinish(previewController: RPPreviewViewController) {
        previewController.dismissViewControllerAnimated(true, completion: nil)
    }
}


