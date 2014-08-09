Spiral
======

A Game Developed with Swift and SpriteKit  

![](http://byetz.img41.wal8.com/img41/425047_20140623222918/140557437844.gif)  

游戏规则是：玩家是五角星小球，小球自动沿着陀螺线向外运动，当玩家点击屏幕时五角星小球会跳跃到内层螺旋，当五角星小球碰到红色旋风或滚动到螺旋线终点时游戏结束。玩家吃掉绿色旋风来得2分，吃到紫色三角得一分并获得保护罩，保护罩用来抵挡一次红色旋风。随着分数的增加游戏会升级，速度加快。游戏结束后可以截屏分享到社交网络，也可以选择重玩。

关于Spiral的教程：http://yulingtianxia.com/blog/2014/07/17/a-ios-game-developed-by-swift-and-spritekit/

如果遇到了类型转换编译报错，可以手动加代码强制转换或者用64位模拟器（如iPhone5s）运行

建议在Xcode6beta3下运行，beta4会出现问题，正在修复中:(

在Xcode6beta4中，SKShapeNode的path无法被绘制出来（Objective-C工作正常），目前没有找到好的解决方法，建议关注stackoverflow：http://stackoverflow.com/questions/24951185/in-xcode-6-beta-4-drawing-a-simple-circle-doesnt-work-anymore

已经修复了Xcode6beta5中因Swift更新产生的语法问题，但依然不能绘制SKShapeNode :(  

苹果官方论坛也有人提出了同样的问题：https://devforums.apple.com/message/1011007#1011007