//
//  GameOverScene.swift
//  FlappyBirdSwift
//
//  Created by Vincent Renais on 2015-05-21.
//  Copyright (c) 2015 Vincent Renais. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {

    var scoreboard = SKSpriteNode()
    
    override func didMoveToView(view: SKView)
    {
        var scoreboardTexture = SKTexture(imageNamed: "img/scoreboard.png")
        scoreboard = SKSpriteNode(texture: scoreboardTexture)
        scoreboard.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        self.addChild(scoreboard)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        
    }

}