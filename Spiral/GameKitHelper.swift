//
//  GameKitHelper.swift
//  Spiral
//
//  Created by 杨萧玉 on 15/9/13.
//  Copyright © 2015年 杨萧玉. All rights reserved.
//

import Foundation
import GameKit

let kHighScoreLeaderboardIdentifier = "com.yulingtianxia.Spiral.HighScores"
let kClean100KillerAchievementID = "com.yulingtianxia.Spiral.clean100Killer"
let kCatch500ScoreAchievementID = "com.yulingtianxia.Spiral.catch500Score"
let kCatch500ShieldAchievementID = "com.yulingtianxia.Spiral.catch500Shield"
let kget50PointsAchievementID = "com.yulingtianxia.Spiral.get50"
let kget100PointsAchievementID = "com.yulingtianxia.Spiral.get100"
let kget200PointsAchievementID = "com.yulingtianxia.Spiral.get200"


let WantGamePauseNotification = "gamepause"


protocol GameKitHelperProtocol: NSObjectProtocol {
    func onScoresSubmitted(_ success:Bool)
}

class GameKitHelper: NSObject, GKGameCenterControllerDelegate {
    var delegate : GameKitHelperProtocol?
    var lastError : NSError? {
        willSet(newError) {
            if newError != nil {
                print("GameKitHelper ERROR: \(newError!.userInfo.description)")
            }
        }
    }
    var achievementsDictionary: [String:GKAchievement]
    var submitScoreWithCompletionHandler: ((_ success: Bool)->Void)?
    
    fileprivate var gameCenterFeaturesEnabled: Bool = false
    
    fileprivate static let sharedInstance = GameKitHelper()
    
    class var sharedGameKitHelper: GameKitHelper {
        return sharedInstance
    }
    
    override init() {
        achievementsDictionary = [String:GKAchievement]()
        super.init()
        
    }
    
    //MARK: - Player Authentication
    
    func authenticateLocalPlayer() {
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = { [unowned localPlayer] (viewController, error) in
            self.lastError = error as NSError?
            if localPlayer.isAuthenticated {
                self.gameCenterFeaturesEnabled = true
                self.submitScoreWithCompletionHandler?(true)
                self.loadAchievements()
            }
            else if let vc = viewController {
                self.pause()
                self.presentViewController(vc)
            }
            else {
                self.gameCenterFeaturesEnabled = false
                self.submitScoreWithCompletionHandler?(false)
            }
        }
    }
    
    //MARK: - UIViewController stuff
    
    func getRootViewController() -> UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController;
    }
    
    func presentViewController(_ vc: UIViewController) {
        let rootVC = self.getRootViewController()
        rootVC?.present(vc, animated: true, completion: nil)
    }
    
    // MARK: - GameKitHelperProtocol
    
    func submitScore(_ score: Int64, identifier: String) {
        //1: Check if Game Center features are enabled
        guard gameCenterFeaturesEnabled else {
            submitScoreWithCompletionHandler?(false)
            return
        }
        //2: Create a GKScore object
        let gkScore = GKScore(leaderboardIdentifier: identifier)
        //3: Set the score value
        gkScore.value = score
        //4: Send the score to Game Center
        GKScore.report([gkScore], withCompletionHandler: { (error) -> Void in
            self.lastError = error as NSError?
            let success = (error == nil)
            self.submitScoreWithCompletionHandler?(success)
            self.delegate?.onScoresSubmitted(success)
        }) 
    }
    
    func pause() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: WantGamePauseNotification), object: nil)
    }
    
    //MARK: - Achievements Methods
    
    func loadAchievements() {
        GKAchievement.loadAchievements { (achievements, error) -> Void in
            if let achievements = achievements , error == nil {
                for achievement in achievements {
                    self.achievementsDictionary[achievement.identifier!] = achievement
                }
            }
        }
    }
    
    func getAchievementForIdentifier(_ identifier: String) -> GKAchievement {
        guard let achievement = achievementsDictionary[identifier] else {
            let achievement = GKAchievement(identifier: identifier)
            achievementsDictionary[achievement.identifier!] = achievement
            return achievement;
        }
        return achievement;
    }
    
    func updateAchievement(_ achievement: GKAchievement, identifier: String) {
        achievementsDictionary[identifier] = achievement
    }
    
    func reportMultipleAchievements() {
        GKAchievement.report(Array(achievementsDictionary.values), withCompletionHandler: { (error) -> Void in
            if error != nil {
                fatalError("Error in reporting achievements:\(error)")
            }
        }) 
    }
    
    func showLeaderboard() {
        let gameCenterController = GKGameCenterViewController()
        pause()
        gameCenterController.gameCenterDelegate = self
        gameCenterController.viewState = .achievements
        presentViewController(gameCenterController)
    }
    
    //MARK: - GKGameCenterControllerDelegate
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        getRootViewController()?.dismiss(animated: true, completion: nil)
    }
}
