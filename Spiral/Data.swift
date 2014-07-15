//
//  Data.swift
//  Spiral
//
//  Created by 杨萧玉 on 14-7-15.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

struct Data{
    static var display:DisplayData?
    static var score:Int = 0{
    willSet{

    }
    didSet{
        display?.updateData()
    }
    }
    static var gameOver:Bool = false {
    willSet{
            
    }
    didSet{
        display?.updateData()
    }
    }
}