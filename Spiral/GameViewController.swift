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

open class GameViewController: UIViewController, RPPreviewViewControllerDelegate, UIGestureRecognizerDelegate {

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
    
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        // Configure the view.
        let skView = self.view as! SKView
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        longPress = UILongPressGestureRecognizer(target: self, action: #selector(GameViewController.handleLongPressGesture(_:)))
        longPress.delegate = self
        
        tapWithOneFinger = UITapGestureRecognizer(target: self, action: #selector(GameViewController.handleTapWithOneFingerGesture(_:)))
        tapWithTwoFinger = UITapGestureRecognizer(target: self, action: #selector(GameViewController.handleTapWithTwoFingerGesture(_:)))
        tapWithTwoFinger.numberOfTouchesRequired = 2
        tapWithTwoFinger.delegate = self
        
        pan = UIPanGestureRecognizer(target: self, action: #selector(GameViewController.handlePanGesture(_:)))
        pan.maximumNumberOfTouches = 1
        pan.delegate = self
        
        pinch = UIPinchGestureRecognizer(target: self, action: #selector(GameViewController.handlePinchGesture(_:)))
        pinch.delegate = self
        
        swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(GameViewController.swipeRight(_:)))
        swipeRight.direction = .right
        swipeRight.delegate = self
        
        swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(GameViewController.swipeLeft(_:)))
        swipeLeft.direction = .left
        swipeLeft.delegate = self
        
        swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(GameViewController.swipeUp(_:)))
        swipeUp.direction = .up
        swipeUp.delegate = self
        
        swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(GameViewController.swipeDown(_:)))
        swipeDown.direction = .down
        swipeDown.delegate = self
        
        screenEdgePanRight = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(GameViewController.handleEdgePanGesture(_:)))
        screenEdgePanRight.edges = UIRectEdge.left
        screenEdgePanRight.delegate = self
        
        let scene = MainScene(size: skView.bounds.size)
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .aspectFit
        skView.presentScene(scene)
        
    }

    override open var shouldAutorotate : Bool {
        return true
    }

    override open var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return UIInterfaceOrientationMask.allButUpsideDown
        } else {
            return UIInterfaceOrientationMask.all
        }
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override open var prefersStatusBarHidden : Bool {
        return true
    }
    
    // MARK: - handle gestures
    func handleLongPressGesture(_ recognizer:UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            ((self.view as! SKView).scene as? GameScene)?.pause()
        }
    }
    
    func handleTapWithOneFingerGesture(_ recognizer:UILongPressGestureRecognizer) {
        if recognizer.state == .ended {
            ((self.view as! SKView).scene as? GameScene)?.tap()
        }
    }
    
    func handleTapWithTwoFingerGesture(_ recognizer:UILongPressGestureRecognizer) {
        if recognizer.state == .ended {
//            ((self.view as! SKView).scene as? OrdinaryModeScene)?.createReaper()
        }
    }
    
    func handlePanGesture(_ recognizer:UIPanGestureRecognizer) {
        if recognizer.state == .changed {
            ((self.view as! SKView).scene as? OrdinaryHelpScene)?.lightWithFinger(recognizer.location(in: self.view))
            ((self.view as! SKView).scene as? ZenHelpScene)?.lightWithFinger(recognizer.location(in: self.view))
            ((self.view as! SKView).scene as? MazeHelpScene)?.lightWithFinger(recognizer.location(in: self.view))
        }
        else if recognizer.state == .ended {
            ((self.view as! SKView).scene as? OrdinaryHelpScene)?.turnOffLight()
            ((self.view as! SKView).scene as? ZenHelpScene)?.turnOffLight()
            ((self.view as! SKView).scene as? MazeHelpScene)?.turnOffLight()
        }
    }
    
    
    func swipeRight(_ sender: UISwipeGestureRecognizer) {
        ((self.view as! SKView).scene as? MazeModeScene)?.playerDirection = .right
    }
    
    func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        ((self.view as! SKView).scene as? MazeModeScene)?.playerDirection = .left
    }
    
    func swipeUp(_ sender: UISwipeGestureRecognizer) {
        ((self.view as! SKView).scene as? MazeModeScene)?.playerDirection = .up
    }
    
    func swipeDown(_ sender: UISwipeGestureRecognizer) {
        ((self.view as! SKView).scene as? MazeModeScene)?.playerDirection = .down
    }
    
    func handlePinchGesture(_ recognizer:UIPinchGestureRecognizer) {
        if recognizer.state == .began {
            if recognizer.scale > 1 {
                ((self.view as! SKView).scene as? GameScene)?.createReaper()
            }
            else {
                ((self.view as! SKView).scene as? GameScene)?.allShapesJumpIn()
            }
        }
    }
    
    func handleEdgePanGesture(_ recognizer:UIPinchGestureRecognizer) {
        if recognizer.state == .ended {
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
                GameKitHelper.sharedGameKitHelper.pause()
                let alert = UIAlertController(title: NSLocalizedString("Quit Game?", comment: ""), message: "", preferredStyle: .alert)
                let quit = UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .default, handler: { (action) -> Void in
                    DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async { () -> Void in
                        if Data.sharedData.gameOver {
                            return
                        }
                        let skView = self.view as! SKView
                        (skView.scene as? GameScene)?.resume()
                        Data.sharedData.display = nil
                        Data.sharedData.gameOver = true
                        Data.sharedData.reset()
                        scene.soundManager.stopBackGround()
                        self.stopRecord()
                        let scene = MainScene(size: skView.bounds.size)
                        let push = SKTransition.push(with: SKTransitionDirection.right, duration: 1)
                        push.pausesIncomingScene = false
                        DispatchQueue.main.async(execute: { () -> Void in
                            skView.presentScene(scene, transition: push)
                            self.removeGestureRecognizers()
                        })
                    }
                })
                let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
                alert.addAction(quit)
                alert.addAction(cancel)
                present(alert, animated: true, completion: nil)
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
    
    func startRecordWithHandler(_ handler:@escaping () -> Void) {
        previewViewController = nil
        guard Data.sharedData.autoRecord else {
            handler()
            return
        }
        RPScreenRecorder.shared().startRecording(withMicrophoneEnabled: true) { (error) -> Void in
            if let rpError = error , rpError._domain == RPRecordingErrorDomain {
                let alert = UIAlertController(title: NSLocalizedString("Sorry", comment: ""), message: NSLocalizedString("The screen recorder is not working", comment: ""), preferredStyle: .alert)
                let action = UIAlertAction(title: "(⊙o⊙)", style: .default, handler: { (action) -> Void in
                    handler()
                })
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                return
            }
            handler()
        }
    }
    
    func stopRecord() {
        RPScreenRecorder.shared().stopRecording(handler: { (previewViewController, ErrorType) -> Void in
            self.previewViewController = previewViewController
            previewViewController?.previewControllerDelegate = self
        })
    }
    
    func discardRecordWithHandler(_ handler:@escaping () -> Void) {
        RPScreenRecorder.shared().discardRecording(handler: handler)
    }
    
    func playRecord() {
        guard let pvController = previewViewController else {
            let alert = UIAlertController(title: NSLocalizedString("Sorry", comment: ""), message: NSLocalizedString("The screen recorder was not started!", comment: ""), preferredStyle: .alert)
            let action = UIAlertAction(title: NSLocalizedString("I'm FINE", comment: ""), style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        pvController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        present(pvController, animated: true, completion:nil)
    }
    
    // MARK: - RPPreviewViewControllerDelegate
    open func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        previewController.dismiss(animated: true, completion: nil)
    }
    
//    MARK: - UIGestureRecognizerDelegate
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == pan || otherGestureRecognizer == pan {
            return true
        }
        return false
    }
}


