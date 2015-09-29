//
//  MazeModeScene.swift
//  Spiral
//
//  Created by 杨萧玉 on 15/9/29.
//  Copyright © 2015年 杨萧玉. All rights reserved.
//

import SpriteKit

protocol MazeModeSceneDelegate: class, SKSceneDelegate {
    var hasPowerup: Bool {get set}
    var playerDirection: PlayerDirection {get set}
    
    func scene(scene: MazeModeScene, didMoveToView view: SKView)
}

class MazeModeScene: SKScene {
    //TODO: 需要注意这个 delegate 没写完，曾用 dynamic 和 assign
    weak var mazeDelegate: MazeModeSceneDelegate?
    
    override func didMoveToView(view: SKView) {
        mazeDelegate?.scene(self, didMoveToView: view)
    }
    
    func pointForGridPosition(position: vector_int2) -> CGPoint {
        return CGPoint(x: position.x * mazeCellWidth + mazeCellWidth / 2, y: position.y * mazeCellWidth  + mazeCellWidth / 2)
    }
}
