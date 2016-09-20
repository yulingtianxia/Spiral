//
//  MazeMap.swift
//  Spiral
//
//  Created by 杨萧玉 on 15/9/29.
//  Copyright © 2015年 杨萧玉. All rights reserved.
//

import GameplayKit
import SpriteKit

enum TileType: Int {
    case open
    case wall
    case portal
    case start
    case none
}

private let Maze = [
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    1,1,1,1,2,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    1,1,1,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,1,
    1,1,1,1,0,1,0,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,
    1,1,1,1,0,1,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,1,
    1,1,1,1,0,1,0,1,1,0,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,0,1,1,0,1,
    1,1,1,1,0,1,0,1,1,0,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,0,1,1,0,1,
    1,1,1,1,0,1,0,1,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,1,0,1,
    1,1,1,1,0,1,0,1,1,0,1,0,1,1,1,1,0,1,1,1,1,1,1,1,1,1,0,1,0,1,1,0,1,
    1,1,1,1,0,1,0,1,1,0,1,0,1,1,0,0,0,0,0,0,0,0,0,0,1,1,0,1,0,1,1,0,1,
    1,1,1,1,0,1,0,1,1,0,1,0,1,1,0,1,0,1,1,1,1,1,1,0,1,1,0,1,0,1,1,0,1,
    1,1,1,1,0,1,0,1,1,0,1,0,1,1,0,1,0,1,1,1,1,1,1,0,1,1,0,1,0,1,1,0,1,
    1,1,1,1,0,1,0,1,1,0,1,0,1,1,0,1,0,0,0,0,0,0,1,0,1,1,0,1,0,1,1,0,1,
    1,1,1,1,0,1,0,1,1,0,1,0,1,1,0,1,0,1,1,1,1,0,1,0,1,1,0,1,0,1,1,0,1,
    1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
    1,0,1,1,0,1,0,1,1,0,1,0,1,1,1,1,0,1,0,1,1,0,1,0,1,1,0,1,0,1,1,1,1,
    1,0,1,1,0,1,0,1,1,0,1,0,0,0,0,0,0,1,0,1,1,0,1,0,1,1,0,1,0,1,1,1,1,
    1,0,1,1,0,1,0,1,1,0,1,1,1,1,1,1,0,1,0,1,1,0,1,0,1,1,0,1,0,1,1,1,1,
    1,0,1,1,0,1,0,1,1,0,1,1,1,1,1,1,0,1,0,1,1,0,1,0,1,1,0,1,0,1,1,1,1,
    1,0,1,1,0,1,0,1,1,0,0,0,0,0,0,0,0,0,0,1,1,0,1,0,1,1,0,1,0,1,1,1,1,
    1,0,1,1,0,1,0,1,1,1,1,1,1,1,1,1,0,1,1,1,1,0,1,0,1,1,0,1,0,1,1,1,1,
    1,0,1,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,1,0,1,0,1,1,1,1,
    1,0,1,1,0,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,0,1,1,0,1,0,1,1,1,1,
    1,0,1,1,0,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,0,1,1,0,1,0,1,1,1,1,
    1,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,1,0,1,1,1,1,
    1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,0,1,0,1,1,1,1,
    1,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,1,1,1,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,2,1,1,1,1,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
]

private let MazeWidth: Int32 = 33
private let MazeHeight: Int32 = 33

private func tileAtRow(_ row: Int32, column col: Int32) -> TileType {
    return  TileType(rawValue: Maze[Int(row * MazeWidth + col)]) ?? .none
}

class MazeMap: SKNode {
    
    let width = MazeWidth
    
    let height = MazeHeight
    
    let pathfindingGraph: GKGridGraph = GKGridGraph(fromGridStartingAt: vector_int2(0, 0), width: MazeWidth, height: MazeHeight, diagonalsAllowed: false)
    
    var startPosition: GKGridGraphNode
    
    let shapeStartPositions: [GKGridGraphNode]
    
    init(size: CGSize) {
        
        var walls = [GKGridGraphNode]()
        var spawnPoints = [GKGridGraphNode]()
        startPosition = GKGridGraphNode(gridPosition: vector_int2(0, 0))
        
        for j in 0 ..< height {
            for i in 0 ..< width {
                let tile = tileAtRow(height - 1 - j, column: i)
                switch tile {
                case .wall:
                    if let wall = pathfindingGraph.node(atGridPosition: vector_int2(i, j)) {
                        walls.append(wall)
                    }
                case .portal:
                    if let portal = pathfindingGraph.node(atGridPosition: vector_int2(i, j)) {
                        spawnPoints.append(portal)
                    }
                case .start:
                    startPosition = pathfindingGraph.node(atGridPosition: vector_int2(i, j))!
                default:
                    break
                }
            }
        }
        
        pathfindingGraph.remove(walls)
        shapeStartPositions = spawnPoints
        
        super.init()
        
        addMagicRoads()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pointForGridPosition(_ position: vector_int2) -> CGPoint {
        let center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
        let deltaX = (position.x - MazeWidth / 2) * mazeCellWidth
        let deltaY = (position.y - MazeHeight / 2) * mazeCellWidth
        return CGPoint(x: center.x + deltaX , y: center.y + deltaY)
    }
    
    func addMagicRoads() {
        // Generate maze.
        let graph = pathfindingGraph
        for j in 0 ..< height {
            for i in 0 ..< width {
                if graph.node(atGridPosition: vector_int2(i, j)) != nil {
                    let node = MagicRoad(graph: graph, position: vector_int2(i, j))
                    node.position = pointForGridPosition(vector_int2(i, j))
                    addChild(node)
                }
            }
        }
    }
}
