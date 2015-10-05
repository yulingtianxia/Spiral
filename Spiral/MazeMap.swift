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
    case Open
    case Wall
    case Portal
    case Start
    case None
}

private let Maze = [
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    1,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,1,
    1,0,1,1,0,1,1,1,1,0,1,1,1,1,1,1,1,1,0,1,1,1,1,0,1,1,0,1,
    1,0,1,1,0,1,1,1,1,0,1,1,1,1,1,1,1,1,0,1,1,1,1,0,1,1,0,1,
    1,0,1,1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,1,1,0,1,
    1,0,1,1,1,1,0,1,1,0,1,1,1,1,1,1,1,1,0,1,1,0,1,1,1,1,0,1,
    1,0,1,1,1,1,0,1,1,0,1,1,1,1,1,1,1,1,0,1,1,0,1,1,1,1,0,1,
    1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,
    1,1,1,0,1,1,0,1,1,1,1,1,0,1,1,0,1,1,1,1,1,0,1,1,0,1,1,1,
    1,1,1,0,1,1,0,1,1,1,1,1,0,1,1,0,1,1,1,1,1,0,1,1,0,1,1,1,
    1,1,1,0,1,1,0,1,1,1,1,1,0,1,1,0,1,1,1,1,1,0,1,1,0,1,1,1,
    1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,1,
    1,0,1,1,1,1,1,1,1,0,1,1,0,1,1,0,1,1,0,1,1,1,1,1,1,1,0,1,
    1,0,1,1,1,1,1,1,1,0,1,1,0,1,1,0,1,1,0,1,1,1,1,1,1,1,0,1,
    1,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,1,
    1,0,1,1,0,1,1,1,1,0,1,1,0,1,1,0,1,1,0,1,1,1,1,0,1,1,0,1,
    1,0,1,1,0,1,1,1,1,0,1,1,0,3,4,0,1,1,0,1,1,1,1,0,1,1,0,1,
    1,0,1,1,0,1,1,1,1,0,1,1,0,1,1,0,1,1,0,1,1,1,1,0,1,1,0,1,
    1,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,1,
    1,0,1,1,0,1,1,1,1,0,1,1,1,1,1,1,1,1,0,1,1,1,1,0,1,1,0,1,
    1,0,1,1,0,1,1,1,1,0,1,1,1,1,1,1,1,1,0,1,1,1,1,0,1,1,0,1,
    1,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,1,
    1,1,1,1,0,1,1,0,1,1,1,1,0,1,1,0,1,1,1,1,0,1,1,0,1,1,1,1,
    1,1,1,1,0,1,1,0,1,1,1,1,0,1,1,0,1,1,1,1,0,1,1,0,1,1,1,1,
    1,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,1,
    1,0,1,1,1,1,1,1,1,0,1,1,0,1,1,0,1,1,0,1,1,1,1,1,1,1,0,1,
    1,0,1,1,1,1,1,1,1,0,1,1,0,1,1,0,1,1,0,1,1,1,1,1,1,1,0,1,
    1,0,0,0,0,0,0,1,1,0,0,0,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,1,
    1,0,1,1,1,1,0,1,1,0,1,1,1,1,1,1,1,1,0,1,1,0,1,1,1,1,0,1,
    1,0,1,1,1,1,0,1,1,0,1,1,1,1,1,1,1,1,0,1,1,0,1,1,1,1,0,1,
    1,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,1,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
]

private let MazeWidth: Int32 = 28
private let MazeHeight: Int32 = 32

private func tileAtRow(row: Int32, column col: Int32) -> TileType {
    return  TileType(rawValue: Maze[Int(row * MazeWidth + col)]) ?? .None
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
                case .Wall:
                    if let wall = pathfindingGraph.nodeAtGridPosition(vector_int2(i, j)) {
                        walls.append(wall)
                    }
                case .Portal:
                    if let portal = pathfindingGraph.nodeAtGridPosition(vector_int2(i, j)) {
                        spawnPoints.append(portal)
                    }
                case .Start:
                    startPosition = pathfindingGraph.nodeAtGridPosition(vector_int2(i, j))!
                default:
                    break
                }
            }
        }
        
        pathfindingGraph.removeNodes(walls)
        shapeStartPositions = spawnPoints
        
        super.init()
        
        // Generate maze.
        let cellSize = CGSize(width: mazeCellWidth, height: mazeCellWidth)
        let graph = pathfindingGraph
        for j in 0 ..< height {
            for i in 0 ..< width {
                if graph.nodeAtGridPosition(vector_int2(i, j)) != nil {
                    //TODO:  绘制地图：墙和道路
                    let node = SKSpriteNode(color: SKColor.whiteColor(), size: cellSize)
                    node.position = pointForGridPosition(vector_int2(i, j))
                    addChild(node)
                }
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
