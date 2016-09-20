//
//  SpiralTests.swift
//  SpiralTests
//
//  Created by 杨萧玉 on 14-7-12.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

import UIKit
import XCTest
import SpriteKit
import Spiral

class SpiralTests: XCTestCase {
    fileprivate var myApp:UIApplication!
    fileprivate var gameVC:GameViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        myApp = UIApplication.shared
        gameVC = myApp.keyWindow?.rootViewController as! GameViewController
//        GameKitHelper.sharedGameKitHelper.authenticateLocalPlayer()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGenerateMapPerformance() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
            _ = OrdinaryMap(origin:CGPoint.zero, layer: 5, size:CGSize(width: 320, height: 576))
        }
    }
    
    func testGameSceneLoaded(){
        let scene = (gameVC.view as! SKView).scene
        XCTAssertNotNil(scene, "game scene not loaded")
    }
    
    func testGameCenterLogin(){
        let expectation = self.expectation(description: "login game center")
        GameKitHelper.sharedGameKitHelper.submitScoreWithCompletionHandler = {(success:Bool) in
            XCTAssert(success, "failed to login game center")
            expectation.fulfill()
        }
        GameKitHelper.sharedGameKitHelper.authenticateLocalPlayer()
        waitForExpectations(timeout: 1000, handler: { (error) -> Void in
            
        })
    }
    
    func testSubmitScore(){
        let expectation = self.expectation(description: "submit score")
        GameKitHelper.sharedGameKitHelper.submitScoreWithCompletionHandler = {(success:Bool) in
            XCTAssert(success, "failed to submit score")
            expectation.fulfill()
        }
        GameKitHelper.sharedGameKitHelper.submitScore(Int64(Data.sharedData.score), identifier: kHighScoreLeaderboardIdentifier)
        waitForExpectations(timeout: 1000, handler: { (error) -> Void in

        })
    }
    
}
