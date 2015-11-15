//
//  GameViewController.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-7-12.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import UIKit
import SpriteKit
import ReplayKit

public class GameViewController: UIViewController, RPPreviewViewControllerDelegate, UIGestureRecognizerDelegate {

    var longPress:UILongPressGestureRecognizer!
    var tapWithOneFinger:UITapGestureRecognizer!
    var tapWithTwoFinger:UITapGestureRecognizer!
    var pan:UIPanGestureRecognizer!
    var pinch:UIPinchGestureRecognizer!
    var swipeRight:UISwipeGestureRecognizer!
    var swipeLeft:UISwipeGestureRecognizer!
    var swipeUp:UISwipeGestureRecognizer!
    var swipeDown:UISwipeGestureRecognizer!
    var screenEdgePanRight:UIScreenEdgePanGestureRecognizer!
    var previewViewController:RPPreviewViewController?
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Configure the view.
        let skView = self.view as! SKView
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        longPress = UILongPressGestureRecognizer(target: self, action: Selector("handleLongPressGesture:"))
        longPress.delegate = self
        
        tapWithOneFinger = UITapGestureRecognizer(target: self, action: Selector("handleTapWithOneFingerGesture:"))
        tapWithTwoFinger = UITapGestureRecognizer(target: self, action: Selector("handleTapWithTwoFingerGesture:"))
        tapWithTwoFinger.numberOfTouchesRequired = 2
        tapWithTwoFinger.delegate = self
        
        pan = UIPanGestureRecognizer(target: self, action: Selector("handlePanGesture:"))
        pan.maximumNumberOfTouches = 1
        pan.delegate = self
        
        pinch = UIPinchGestureRecognizer(target: self, action: Selector("handlePinchGesture:"))
        pinch.delegate = self
        
        swipeRight = UISwipeGestureRecognizer(target: self, action: Selector("swipeRight:"))
        swipeRight.direction = .Right
        swipeRight.delegate = self
        
        swipeLeft = UISwipeGestureRecognizer(target: self, action: Selector("swipeLeft:"))
        swipeLeft.direction = .Left
        swipeLeft.delegate = self
        
        swipeUp = UISwipeGestureRecognizer(target: self, action: Selector("swipeUp:"))
        swipeUp.direction = .Up
        swipeUp.delegate = self
        
        swipeDown = UISwipeGestureRecognizer(target: self, action: Selector("swipeDown:"))
        swipeDown.direction = .Down
        swipeDown.delegate = self
        
        screenEdgePanRight = UIScreenEdgePanGestureRecognizer(target: self, action: Selector("handleEdgePanGesture:"))
        screenEdgePanRight.edges = UIRectEdge.Left
        screenEdgePanRight.delegate = self
        
        let scene = MainScene(size: skView.bounds.size)
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFit
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
            ((self.view as! SKView).scene as? MazeHelpScene)?.lightWithFinger(recognizer.locationInView(self.view))
        }
        else if recognizer.state == .Ended {
            ((self.view as! SKView).scene as? OrdinaryHelpScene)?.turnOffLight()
            ((self.view as! SKView).scene as? ZenHelpScene)?.turnOffLight()
            ((self.view as! SKView).scene as? MazeHelpScene)?.turnOffLight()
        }
    }
    
    
    func swipeRight(sender: UISwipeGestureRecognizer) {
        ((self.view as! SKView).scene as? MazeModeScene)?.playerDirection = .Right
    }
    
    func swipeLeft(sender: UISwipeGestureRecognizer) {
        ((self.view as! SKView).scene as? MazeModeScene)?.playerDirection = .Left
    }
    
    func swipeUp(sender: UISwipeGestureRecognizer) {
        ((self.view as! SKView).scene as? MazeModeScene)?.playerDirection = .Up
    }
    
    func swipeDown(sender: UISwipeGestureRecognizer) {
        ((self.view as! SKView).scene as? MazeModeScene)?.playerDirection = .Down
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
            else if let scene = scene as? MazeHelpScene {
                scene.back()
            }
            else if let scene = scene as? GameScene {
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)) { () -> Void in
                    if Data.sharedData.gameOver {
                        return
                    }
                    let skView = self.view as! SKView
                    Data.sharedData.display = nil
                    Data.sharedData.gameOver = true
                    Data.sharedData.reset()
                    scene.soundManager.stopBackGround()
                    self.stopRecord()
                    let scene = MainScene(size: skView.bounds.size)
                    let push = SKTransition.pushWithDirection(SKTransitionDirection.Right, duration: 1)
                    push.pausesIncomingScene = false
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        skView.presentScene(scene, transition: push)
                        self.removeGestureRecognizers()
                    })
                }
            }
        }
    }
    
    // MARK: - add&remove gesture recognizers
    func addGestureRecognizers() {
        let skView = self.view as! SKView
        
        skView.addGestureRecognizer(swipeRight)
        skView.addGestureRecognizer(swipeLeft)
        skView.addGestureRecognizer(swipeUp)
        skView.addGestureRecognizer(swipeDown)
        
        skView.addGestureRecognizer(tapWithOneFinger)
        
        skView.addGestureRecognizer(screenEdgePanRight)
        skView.addGestureRecognizer(pan)
        skView.addGestureRecognizer(longPress)
        skView.addGestureRecognizer(pinch)
        skView.addGestureRecognizer(tapWithTwoFinger)
    }
    
    func removeGestureRecognizers() {
        let skView = self.view as! SKView
        skView.removeGestureRecognizer(longPress)
        skView.removeGestureRecognizer(tapWithOneFinger)
        skView.removeGestureRecognizer(tapWithTwoFinger)
        skView.removeGestureRecognizer(pan)
        skView.removeGestureRecognizer(pinch)
        skView.removeGestureRecognizer(swipeRight)
        skView.removeGestureRecognizer(swipeLeft)
        skView.removeGestureRecognizer(swipeUp)
        skView.removeGestureRecognizer(swipeDown)
        skView.removeGestureRecognizer(screenEdgePanRight)
    }
    
    // MARK: - record game
    
    func startRecordWithHandler(handler:() -> Void) {
        previewViewController = nil
        guard Data.sharedData.autoRecord else {
            handler()
            return
        }
        RPScreenRecorder.sharedRecorder().startRecordingWithMicrophoneEnabled(true) { (error) -> Void in
            if let rpError = error where rpError.domain == RPRecordingErrorDomain {
                let alert = UIAlertController(title: "😌", message: "🚫🎥", preferredStyle: .Alert)
                let action = UIAlertAction(title: "(⊙o⊙)", style: .Default, handler: { (action) -> Void in
                    handler()
                })
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            handler()
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
        guard let pvController = previewViewController else {
            let alert = UIAlertController(title: "😌", message: "🙈🎥", preferredStyle: .Alert)
            let action = UIAlertAction(title: "😭", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        pvController.modalPresentationStyle = UIModalPresentationStyle.FullScreen
        presentViewController(pvController, animated: true, completion:nil)
    }
    
    // MARK: - RPPreviewViewControllerDelegate
    public func previewControllerDidFinish(previewController: RPPreviewViewController) {
        previewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
//    MARK: - UIGestureRecognizerDelegate
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == pan || otherGestureRecognizer == pan {
            return true
        }
        return false
    }
}


