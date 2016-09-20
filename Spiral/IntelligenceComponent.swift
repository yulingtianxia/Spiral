//
//  IntelligenceComponent.swift
//  Spiral
//
//  Created by 杨萧玉 on 15/9/30.
//  Copyright © 2015年 杨萧玉. All rights reserved.
//

import GameplayKit

class IntelligenceComponent: GKComponent {
    let stateMachine: GKStateMachine
    
    init(scene: MazeModeScene, entity: Entity, startingPosition origin: GKGridGraphNode) {
        let chase = ShapeChaseState(scene: scene, entity: entity)
        let flee = ShapeFleeState(scene: scene, entity: entity)
        let defeated = ShapeDefeatedState(scene: scene, entity: entity, respawnPosition: origin)
        let respawn = ShapeRespawnState(scene: scene, entity: entity)
        let reap = ShapeReapState(scene: scene, entity: entity)
        
        stateMachine = GKStateMachine(states: [chase, flee, defeated, respawn, reap])
        
        switch entity.shapeType {
        case .killer:
            stateMachine.enter(ShapeChaseState.self)
        case .score, .shield:
            stateMachine.enter(ShapeFleeState.self)
        case .reaper:
            stateMachine.enter(ShapeReapState.self)
        case .player:
            break
        }
        
        super.init()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        stateMachine.update(deltaTime: seconds)
    }
}
